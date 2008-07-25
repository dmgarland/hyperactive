set :deploy_to, "/home/yossarian/www/london.indymedia.org.uk/current"
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"

role :web, "london.indymedia.org.uk"
role :app, "london.indymedia.org.uk"
role :db,  "london.indymedia.org.uk", :primary => true