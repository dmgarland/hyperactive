require File.dirname(__FILE__) + '/../test_helper'

# The AnonymousUser object is configured in environment.rb

class AnonymousUserTest < Test::Unit::TestCase
  fixtures :roles, :groups, :groups_users, :groups_roles, :static_permissions, :roles_static_permissions
  
  def setup
    # Careful: Because of the nature of Singletons, the AnonymousUser 
    # class will be the same on every run and configuration cannot be
    # changed after the "caching" methods have been called the first 
    # time.
    ActiveRbac.anonymous_user_groups =  ["Cretes", "Greeks"]    
    ActiveRbac.anonymous_user_roles =  ["Greek Kings", "Greek Men"]      
    @user = AnonymousUser.instance
  end
  
  def test_base_configuration_properties
    assert_equal 'anonymous', @user.login
    assert_equal 'nobody@localhost', @user.email
  end
  
  def test_all_roles
    assert_equal [ roles(:greek_kings_role), roles(:greek_men_role) ], @user.all_roles
  end
  
  def test_all_groups
    assert_equal  [groups(:cretes_group), groups(:greeks_group)], @user.all_groups
  end
  
  def test_all_static_permissions
    assert_equal [ @sit_on_throne_permission ], @user.all_static_permissions
  end
  
  def test_has_permission
    assert @user.has_permission?('Sit On Throne')
    assert !@user.has_permission?('Slay Monsters')
  end
  
  def test_has_role
    assert @user.has_role?('Greek Kings')
    assert !@user.has_role?('Gods')
  end
  
  def test_is_anonymous
    assert @user.is_anonymous?
  end
end