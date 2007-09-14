class CreateAclSystem < ActiveRecord::Migration
  def self.up
      create_table "roles", :force => true do |t|
        t.column "title", :string
      end

      create_table "roles_users", :id => false, :force => true do |t|
        t.column "role_id", :integer
        t.column "user_id", :integer
      end

      foreign_key :roles_users, :role_id, :roles
      foreign_key :roles_users, :user_id, :users

  end

  def self.down
    User.transaction do
      Role.delete_all
      drop_table :roles
      drop_table :roles_users
    end
  end
end
