set :deploy_to, "/var/www/stagingsite/"

role :web, "londonstaging.escapegoat.org"
role :app, "londonstaging.escapegoat.org"
role :db,  "londonstaging.escapegoat.org", :primary => true