set :deploy_to, "/home/yossarian/www/london.escapegoat.org/current"
set :mongrel_conf, "#{current_path}/config/mongrel_cluster_staging.yml"

role :web, "london.escapegoat.org"
role :app, "london.escapegoat.org"
role :db,  "london.escapegoat.org", :primary => true