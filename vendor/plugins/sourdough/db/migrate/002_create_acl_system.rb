# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
class CreateAclSystem < ActiveRecord::Migration
  def self.up
      create_table "roles", :force => true do |t|
        t.column "title", :string
      end

      create_table "roles_users", :id => false, :force => true do |t|
        t.column "role_id", :integer
        t.column "user_id", :integer
      end

      add_foreign_key :roles_users, :role_id, :roles
      add_foreign_key :roles_users, :user_id, :users

  end

  def self.down
    User.transaction do
      Role.delete_all
      drop_table :roles_users
      drop_table :roles
    end
  end
end
