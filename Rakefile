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