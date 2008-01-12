# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
class CreateBannedAtOnUser < ActiveRecord::Migration
  def self.up
    Photo.transaction do 
      add_column :photos, :attachable_type, :string
      add_column :photos, :attachable_id, :integer
    end
  end

  def self.down
    Photo.transaction do
      remove_column :photos, :attachable_type
      remove_column :photos, :attachable_id
    end
  end
end
