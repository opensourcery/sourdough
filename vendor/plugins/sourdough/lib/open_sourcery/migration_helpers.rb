# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
module OpenSourcery
  module MigrationHelpers

    # Agile Web Development with Rails example Chapter 16
    def add_foreign_key(from_table, from_column, to_table, to_field="id")
      execute %{alter table #{from_table}
                add constraint 
                  fk_#{from_table}_#{from_column}_#{to_table}_#{to_field}
                foreign key (#{from_column})
                references #{to_table}(#{to_field})}
    end
 
    def remove_foreign_key(from_table, from_column, to_table, to_field="id")
      execute %{alter table #{from_table}
                drop constraint
                  fk_#{from_table}_#{from_column}_#{to_table}_#{to_field}}
    end
 
  end
end

ActiveRecord::Migration.extend OpenSourcery::MigrationHelpers
