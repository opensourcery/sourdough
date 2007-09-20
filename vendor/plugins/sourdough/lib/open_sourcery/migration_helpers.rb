# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
module OpenSourcery
  module MigrationHelpers

    # Agile Web Development with Rails example Chapter 16
    def foreign_key(from_table, from_column, to_table)
      execute %{ alter table #{ from_table}
                add foreign key (#{ from_column})
                references #{ to_table}(id)}
    end

  end
end

ActiveRecord::Migration.extend OpenSourcery::MigrationHelpers
