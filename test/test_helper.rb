ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  def assert_invalid_value(model_class, attribute, value)
    if value.kind_of? Array
      value.each { |v| assert_invalid_value model_class, attribute, v }
    else
      record = model_class.new(attribute => value)
      assert !record.valid?, "#{model_class} expected to be invalid when #{attribute} is #{value}"
      assert record.errors.invalid?(attribute), "#{attribute} expected to be invalid when set to #{value}"
    end
  end 
  
  def assert_valid_value(model_class, attribute, value)
    if value.kind_of? Array
      value.each { |v| assert_valid_value model_class, attribute, v }
    else
      record = model_class.new(attribute => value)
      record.valid? #assert record.valid?, "#{model_class} expected to be valid when #{attribute} is #{value}"
      assert_equal record.errors.invalid?(attribute), false, "#{attribute} expected to be valid when set to #{value}"
    end
  end 
  
  def as_admin
    {:rbac_user_id => users(:marcos).id } 
  end
  
  def as_registered
    {:rbac_user_id => users(:registered_user).id }
  end
  
  fixtures :users, :roles, :roles_users, :static_permissions, :roles_static_permissions
 
end
