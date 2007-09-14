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

      foreign_key :photos, :user_id, :users
  end

  def self.down
    drop_table :photos
  end
end


