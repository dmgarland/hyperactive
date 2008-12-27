# Periodically runs the Xapian index update task so that our
# search indexes stay up to date.
#
class XapianIndexWorker < BackgrounDRb::Rails
  
  repeat_every 60.minutes
  first_run Time.now + 30 # Let's give it 30 seconds for everything else to get warmed up
  
  def do_work(args)
    `cd #{RAILS_ROOT} && RAILS_ENV=#{RAILS_ENV} #{Hyperactive.rake_path} xapian:update_index`
  end

end
