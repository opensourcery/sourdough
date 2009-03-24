# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
class CreateBannedAtOnUser < ActiveRecord::Migration
  def self.up
    User.transaction do 
      add_column :users, :banned_at, :datetime
    end
  end

  def self.down
    User.transaction do
      remove_column :users, :banned_at
    end
  end
end
