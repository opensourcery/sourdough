# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
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
  include ActionView::Helpers::NumberHelper
  belongs_to :user

  has_attachment :content_type => :image,
                 :storage => :file_system,
                 :max_size => 500.kilobytes,
                 :resize_to => '320x200>',
                 :thumbnails => { :thumb => '100x100>' }

  validates_presence_of :size, :content_type, :filename
  validate              :attachment_attributes_valid?

  def attachment_attributes_valid?
    errors.add :size, "of your photo must be less then #{number_to_human_size attachment_options[:max_size]}" unless attachment_options[:size].nil? || attachment_options[:size].include?(send(:size))
    errors.add :content_type, "is not a supported image type.  Please use .gif, .jpg, or .png" unless attachment_options[:content_type].nil? || attachment_options[:content_type].include?(send(:content_type))
  end

end
