# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/switchtower.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

#Rake::RDocTask.new do |rdoc|
#    files = ['README', 'lib/**/*.rb',
#      'doc/**/*.rdoc', 'test/*.rb']
#    rdoc.rdoc_files.add(files)
#    rdoc.main = "README" # page to start on
#    rdoc.title = "My App's Documentation"
#    rdoc.template = "/home/yossarian/software/allison/allison.rb"
#    rdoc.rdoc_dir = 'doc' # rdoc output folder
#    rdoc.options << '--line-numbers' << '--inline-source'
#end

namespace 'views' do
  desc 'Renames all .rhtml views to .html.erb, .rjs to .js.rjs, .rxml to .xml.builder and .haml to .html.haml'
  task 'rename' do
    Dir.glob('app/views/**/[^_]*.rhtml').each do |file|
      puts `svn mv #{file} #{file.gsub(/\.rhtml$/, '.html.erb')}`
    end

    Dir.glob('app/views/**/[^_]*.rjs').each do |file|
      puts `svn mv #{file} #{file.gsub(/\.rjs$/, '.js.rjs')}`
    end

    Dir.glob('app/views/**/[^_]*.rxml').each do |file|
      puts `svn mv #{file} #{file.gsub(/\.rxml$/, '.xml.builder')}`
    end

    Dir.glob('app/views/**/[^_]*.haml').each do |file|
      puts `svn mv #{file} #{file.gsub(/\.haml$/, '.html.haml')}`
    end
  end
end

