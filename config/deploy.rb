require 'capistrano/ext/multistage'

# This defines a deployment "recipe" that you can feed to capistrano
# (http://manuals.rubyonrails.com/read/book/17). It allows you to automate
# (among other things) the deployment of your application.

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The deploy_to path must be the path on each machine that will
# form the root of the application path.

set :application, "hyperactive"
set :repository, "git://git.escapegoat.org/hyperactive.git"
set(:rails_env) { "#{stage}" }
set :user, "yossarian"            # defaults to the currently logged in user
set :keep_releases, 2            # number of deployed releases to keep
set :scm, :git               # defaults to :subversion
set :deploy_via, :remote_cache

# =============================================================================
# SSH OPTIONS
# =============================================================================
# ssh_options[:keys] = %w(/path/to/my/key /path/to/another/key)
# ssh_options[:port] = 25

# =============================================================================
# TASKS
# =============================================================================
# Define tasks that run on all (or only some) of the machines. You can specify
# a role (or set of roles) that each task should be executed on. You can also
# narrow the set of servers to a subset of a role by specifying options, which
# must match the options given for the servers to select (like :primary => true)

desc <<DESC
An imaginary backup task. (Execute the 'show_tasks' task to display all
available tasks.)
DESC
task :backup, :roles => :db, :only => { :primary => true } do
  # the on_rollback handler is only executed if this task is executed within
  # a transaction (see below), AND it or a subsequent task fails.
  on_rollback { delete "/tmp/dump.sql" }

  run "mysqldump -u theuser -p thedatabase > /tmp/dump.sql" do |ch, stream, out|
    ch.send_data "thepassword\n" if out =~ /^Enter password:/
  end
end

# Tasks may take advantage of several different helper methods to interact
# with the remote server(s). These are:
#
# * run(command, options={}, &block): execute the given command on all servers
#   associated with the current task, in parallel. The block, if given, should
#   accept three parameters: the communication channel, a symbol identifying the
#   type of stream (:err or :out), and the data. The block is invoked for all
#   output from the command, allowing you to inspect output and act
#   accordingly.
# * sudo(command, options={}, &block): same as run, but it executes the command
#   via sudo.
# * delete(path, options={}): deletes the given file or directory from all
#   associated servers. If :recursive => true is given in the options, the
#   delete uses "rm -rf" instead of "rm -f".
# * put(buffer, path, options={}): creates or overwrites a file at "path" on
#   all associated servers, populating it with the contents of "buffer". You
#   can specify :mode as an integer value, which will be used to set the mode
#   on the file.
# * render(template, options={}) or render(options={}): renders the given
#   template and returns a string. Alternatively, if the :template key is given,
#   it will be treated as the contents of the template to render. Any other keys
#   are treated as local variables, which are made available to the (ERb)
#   template.

desc "Demonstrates the various helper methods available to recipes."
task :helper_demo do
  # "setup" is a standard task which sets up the directory structure on the
  # remote servers. It is a good idea to run the "setup" task at least once
  # at the beginning of your app's lifetime (it is non-destructive).
  setup

  buffer = render("maintenance.rhtml", :deadline => ENV['UNTIL'])
  put buffer, "#{shared_path}/system/maintenance.html", :mode => 0644
  sudo "killall -USR1 dispatch.fcgi"
  run "#{release_path}/script/spin"
  delete "#{shared_path}/system/maintenance.html"
end

namespace :deploy do
  
  # This is my experimental solution to the problem of restarting backgroundrb during deployment.
  #
  namespace :backgroundrb do
    
    desc "Start backgroundrb for video encoding"
    task :start do
      run "cd #{deploy_to}current; sudo -u www-data rake backgroundrb:start RAILS_ENV=#{stage}"
    end
    
    desc "Stop backgroundrb for video encoding"
    task :stop do
      run "cd #{deploy_to}current; sudo -u www-data rake backgroundrb:stop RAILS_ENV=#{stage}"
    end
    
    desc "Restart backgroundrb for video encoding"
    task :restart do
      run "cd #{deploy_to}current; sudo -u www-data rake backgroundrb:restart RAILS_ENV=#{stage}"
    end
    
  end # end of backgroundrb namespace
    
  
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "An after-update task to copy the correct database and backgroundrb configurations into place."
  task :after_update_code, :roles => :app do
    db_config = "#{shared_path}/database.yml.production"
    run "cp #{db_config} #{release_path}/config/database.yml"
    mods_config = "#{shared_path}/mods_enabled.list"
    run "cp #{mods_config} #{release_path}/config/mods_enabled.list"
   #backgroundrb_config = "#{shared_path}/backgroundrb.yml.production"
    #run "cp #{backgroundrb_config} #{release_path}/config/backgroundrb.yml"
  end
  
  
  
  # You can use "transaction" to indicate that if any of the tasks within it fail,
  # all should be rolled back (for each task that specifies an on_rollback
  # handler).
  
  desc "A task demonstrating the use of transactions."
  task :long_deploy do
    backgroundrb.stop
    transaction do
      chown_current_to_deployment_user
      update_code
      deploy.web:disable
      symlink
      migrate
    end
    restart
    backgroundrb.start
    deploy.web:enable
    cleanup
    chown_to_www_data
  end
  
  desc "Change group to deployment user so perms on the server actually work"
  task :chown_current_to_deployment_user, :roles => [ :app, :db, :web ] do
    sudo "chown -R #{user}:#{user} #{current_path}/*"
  end 
  
  desc "Change group to deployment user so perms on the server actually work"
  task :chown_current_to_deployment_user, :roles => [ :app, :db, :web ] do
    sudo "chown -R #{user}:#{user} #{current_path}/*"
  end   
  
  desc "Change group to www-data"
  task :chown_to_www_data, :roles => [ :app, :db, :web ] do
    sudo "chown -R  www-data:www-data #{current_path}/*"
  end   

end
