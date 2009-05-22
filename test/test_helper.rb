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
      
      # HACK: this allows the Events to bypass their 
      # validate_more_than_two_hours_from_now method
      record.date = 1.day.from_now if model_class == Event
      
      # HACK: this allows ExternalFeeds to bypass the Collective validations 
      # so we can test attributes in isolation
      record.collective_id = collectives(:indy_london).id if model_class == ExternalFeed
      assert !record.valid?, "#{model_class} expected to be invalid when #{attribute} is #{value}"
      assert record.errors.invalid?(attribute), "#{attribute} expected to be invalid when set to #{value}"
    end
  end 
  
  def assert_valid_value(model_class, attribute, value)
    if value.kind_of? Array
      value.each { |v| assert_valid_value model_class, attribute, v }
    else
      record = model_class.new(attribute => value)
      # HACK: this allows the Events to bypass their 
      # validate_more_than_two_hours_from_now method
      record.date = 1.day.from_now if model_class == Event     
      # HACK: this allows ExternalFeeds to bypass the Collective validations 
      # so we can test attributes in isolation
      record.collective_id = 1 if model_class == ExternalFeed
      record.valid? #assert record.valid?, "#{model_class} expected to be valid when #{attribute} is #{value}"
      assert_equal record.errors.invalid?(attribute), false, "#{attribute} expected to be valid when set to #{value}"
    end
  end 
  
  # Asserts that a (usually) logged-in user attempted to do something which 
  # they didnt' have permission to do and got kicked out to the front page
  # of the site.
  #
  def assert_security_error
    assert_redirected_to root_path
    assert_equal I18n.t('security.permissions_error'), flash[:error]
  end
  
  # This asserts that an anonymous user attempted to do something for which 
  # they don't have permission - in this case the standard security code will 
  # store the URI which the user tried to access and temporarily redirect them 
  # to the login page - they will be redirected to the original URI after login 
  # if they have permission.  
  #
  def assert_login_necessary
    assert_redirected_to login_path
    assert_equal I18n.t('security.login_necessary'), flash[:error]
  end  
   
  def as_user(fixture_name)
    {:rbac_user_id => users(fixture_name).id}
  end  
  
  fixtures :slugs, :users, :roles, :roles_users, :static_permissions, :roles_static_permissions, :collectives, :collective_associations, :collective_memberships
 
end
