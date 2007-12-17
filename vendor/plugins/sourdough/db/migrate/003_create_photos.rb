# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
class CreatePhotos < ActiveRecord::Migration
  def self.up
      create_table "photos", :force => true do |t|
        t.column "parent_id",    :integer
        t.column "user_id",      :integer
        t.column "content_type", :string
        t.column "filename",     :string
        t.column "thumbnail",    :string
        t.column "size",         :integer
        t.column "width",        :integer
        t.column "height",       :integer
        t.column "created_at",   :datetime
        t.column "updated_at",   :datetime
      end

      add_foreign_key :photos, :user_id, :users
  end

  def self.down
    drop_table :photos
  end
end


