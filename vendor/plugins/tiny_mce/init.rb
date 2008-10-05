require 'tiny_mce'
TinyMCE::OptionValidator.load
ActionController::Base.class_eval do
  include TinyMCE
end