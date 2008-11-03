require 'net/http'
require 'open-uri'

# Original credits: 
# http://blog.inquirylabs.com/2006/04/13/simple-uri-validation/
# http://www.igvita.com/blog/2006/09/07/validating-url-in-ruby-on-rails/
# HTTP Codes: http://www.ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTPResponse.html

class ActiveRecord::Base
  def self.validates_uri_existence_of(*attr_names)
    configuration = { :message => "is not a valid web address" }
    configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
    validates_each attr_names do |m, a, v|
      begin
        # Try to open the URI
        open v
      rescue
        # Report the error if it throws an exception
        m.errors.add(a, configuration[:message])
      end
    end
  end
end