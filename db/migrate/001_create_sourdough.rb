class CreateSourdough < ActiveRecord::Migration
  def self.up
    Rails.plugins["sourdough"].migrate(6)
  end

  def self.down
    Rails.plugins["sourdough"].migrate(0)
  end
end
