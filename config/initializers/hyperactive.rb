require "hyperactive"

Hyperactive.site_name = "Indymedia London"
Hyperactive.show_site_name_in_banner = false
Hyperactive.banner_image = "logo.png"
Hyperactive.use_ssl = true

# Email configuration
# 
# What address should hide/unhide/inappropriate content notifications be sent to?
#
Hyperactive.moderation_email_recipients = 'imc-london-moderation@lists.indymedia.org'

# Who should moderation emails originate from?
#
Hyperactive.moderation_email_from = "indy site <site@london.indymedia.org.uk>"

require 'tag_extensions'
require 'vpim/icalendar'

ActiveRbac.controller_layout = "admin" 

ROUTES_PROTOCOL = (ENV["RAILS_ENV"] =~ /development/ ? "http://" : "https://")

# The path to rake on this system (usually on a Debian system it'll be at
# /usr/bin/rake).  This is used by the XapianIndexWorker so it can happily
# run rake when it needs to update search indexes. Usually there won't be
# any need to change this, but it might be in a different place on your system.
#
RAKE_PATH = "/usr/bin/rake"