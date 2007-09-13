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
