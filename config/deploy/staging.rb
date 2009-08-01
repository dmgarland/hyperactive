set :deploy_to, "/var/rails/hyperactive.escapegoat.org/"

role :web, "hyperactive.escapegoat.org"
role :app, "hyperactive.escapegoat.org"
role :db,  "hyperactive.escapegoat.org", :primary => true

