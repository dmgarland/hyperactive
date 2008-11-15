class AddDefaultAdminUser < ActiveRecord::Migration
  def self.up
    role = Role.new
    role.title = 'Admin'
    role.save
    
    user = User.new
    user.login = 'admin'
    user.update_password 'password'
    user.email = 'foo@bar.org'
    user.state = User.states['confirmed']
    user.save
    
    user.roles << role
    user.save  
  end

  def self.down
    user = User.find_by_login('admin')
    user.delete  
    role = Role.find_by_title('Admin')
    role.delete  
  end
end
