set :deploy_to, "/var/www/london.indymedia.org.uk/"

role :web, "london.indymedia.org.uk"
role :app, "london.indymedia.org.uk"
role :db,  "london.indymedia.org.uk", :primary => true
