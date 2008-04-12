require 'rubygems'
require 'active_support'
require 'active_record'
require 'test/unit'
require 'fileutils'

RAILS_ENV = 'test' unless defined?(RAILS_ENV)

require File.dirname(__FILE__) + '/../../vendor/plugins/backgroundrb/backgroundrb'
require File.dirname(__FILE__) + '/../../lib/workers/video_conversion_worker'

class VideoConversionWorkerTest < Test::Unit::TestCase

  def setup
    @video = File.dirname(__FILE__) + '/../../test/fixtures/fight_test.wmv'
    FileUtils.remove "#{@video}.small.jpg" if File.exists?("#{@video}.small.jpg")
    FileUtils.remove "#{@video}.jpg" if File.exists?("#{@video}.jpg")
    FileUtils.remove "#{@video}.flv" if File.exists?("#{@video}.flv")
    @middleman = BackgrounDRb::MiddleMan.instance
    @middleman.set_sleep  0.05
    @middleman.start_timer
    @middleman.gc! Time.now 
    class << @middleman
      # cache with named key data and time to live( defaults to 10 minutes).
      # or it can take a 
      def cache_as(named_key, ttl=10*60, content=nil)
        if content
          cache(named_key, ttl, Marshal.dump(content))
          content
        elsif block_given?
          res = yield
          cache(named_key, ttl, Marshal.dump(res))
          res
        end  
      end

      def cache_get(named_key, ttl=10*60)
        if self[named_key]
          return Marshal.load(self[named_key])
        elsif block_given?
          res = yield
          cache(named_key, ttl, Marshal.dump(res))
          res
        else
          return nil    
        end     
      end
    end  
  end  

  def test_includes_drb_undumped
    assert VideoConversionWorker.included_modules.include?(DRbUndumped)
  end
  
  def test_worker_creation_and_deletion
    worker_key = @middleman.new_worker(:class => :video_conversion_worker,
                                    :job_key => "video1", 
                                    :args => {:absolute_path => @video, :video_id => "1" })
    assert_equal 1, @middleman.jobs.keys.length
    assert_equal "video1", @middleman.jobs.keys.first
    assert_equal(1, @middleman.get_worker(worker_key).video_id)
    assert_equal(@video, @middleman.get_worker(worker_key).video_file) 
    sleep 1
    assert File.exists?("#{@video}.jpg")
    assert File.exists?("#{@video}.small.jpg")
    sleep 1
    assert File.exists?("#{@video}.flv")
    @middleman.delete_worker worker_key
    assert_nil @middleman.get_worker(worker_key) 
    assert_nil @middleman.timestamps[worker_key]
  end
  
end
