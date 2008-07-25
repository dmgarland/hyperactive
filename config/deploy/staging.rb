set :deploy_to, "/home/yossarian/www/london.escapegoat.org"

role :web, "london.escapegoat.org"
role :app, "london.escapegoat.org"
role :db,  "london.escapegoat.org", :primary => true