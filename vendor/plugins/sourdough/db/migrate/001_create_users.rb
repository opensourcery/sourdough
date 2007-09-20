# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :last_login_at,             :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :visits_count,              :integer, :default => 0
      t.column :time_zone,                 :string,  :default => 'Pacific Time (US & Canada)'
      t.column :photo_id,                 :integer
    end
  end

  def self.down
    drop_table "users"
  end
end
