set :deploy_to, "/var/www/londonstaging.escapegoat.org/"

role :web, "londonstaging.escapegoat.org"
role :app, "londonstaging.escapegoat.org"
role :db,  "londonstaging.escapegoat.org", :primary => true
