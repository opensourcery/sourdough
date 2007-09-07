# == Schema Information
# Schema version: 19
#
# Table name: photos
#
#  id           :integer(11)   not null, primary key
#  parent_id    :integer(11)
#  content_type :string(255)
#  filename     :string(255)
#  thumbnail    :string(255)
#  size         :integer(11)
#  width        :integer(11)
#  height       :integer(11)
#  created_at   :date
#

class Photo < ActiveRecord::Base
  belongs_to :user

  has_attachment :content_type => :image,
                 :storage => :file_system,
                 :max_size => 500.kilobytes,
                 :resize_to => '320x200>',
                 :thumbnails => { :thumb => '100x100>' }

  validates_as_attachment

end
