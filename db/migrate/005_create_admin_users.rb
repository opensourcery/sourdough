class CreateAdminUsers < ActiveRecord::Migration
  def self.up
    User.create!(:login => 'opensourcery', :email => 'alex@opensourcery.com', :password => 'test', :password_confirmation => 'test' )
    User.create!(:login => 'admin', :email => 'admin@wellgram.com', :password => 'test', :password_confirmation => 'test' )
    Role.create!(:title => 'admin')
    role = Role.find_by_title('admin')
    user = User.find_by_login('opensourcery')
    user.roles << role
    user.save!
    user.activate
    admin_user = User.find_by_login('admin')
    admin_role = Role.find_by_title('admin')
    admin_user.roles << admin_role
    admin_user.save!
    admin_user.activate
  end

  def self.down
  end
end
