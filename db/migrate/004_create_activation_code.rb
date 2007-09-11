class CreateActivationCode < ActiveRecord::Migration
  def self.up
    User.transaction do
      add_column :users, :activation_code, :string, :limit => 40
      add_column :users, :activated_at, :datetime
    end
  end

  def self.down
    User.transaction do
      remove_column :users, :activation_code
      remove_column :users, :activated_at
    end
  end
end
