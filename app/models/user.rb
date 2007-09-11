# == Schema Information
# Schema version: 2
#
# Table name: users
#
#  id                        :integer       not null, primary key
#  login                     :string(255)
#  email                     :string(255)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  last_login_at             :datetime
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  visits_count              :integer       default(0)
#  time_zone                 :string(255)   default("Etc/UTC")
#

require 'digest/sha1'
class User < ActiveRecord::Base
  include AuthenticatedBase

  has_and_belongs_to_many :roles

  belongs_to :photo

  composed_of :tz, :class_name => 'TzinfoTimezone', :mapping => %w( time_zone time_zone )

  validates_format_of :login, :with => /^\w+$/
  validates_email_format_of :email

  # Protect internal methods from mass-update with update_attributes
  attr_accessible :login, :email, :password, :password_confirmation, :time_zone, :activated_at, :activation_code

  def admin?
    roles.map{ |role| role.title}.include? 'admin'
  end

  def to_param
    login
  end

  def self.find_by_param(*args)
    find_by_login *args
  end

  def to_xml
    super( :only => [ :login, :time_zone, :last_login_at ] )
  end

  def reset_password!
    temporary_password = create_temporary_password
    self.password, self.password_confirmation = temporary_password, temporary_password
    save!
  end

  private

  def create_temporary_password
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    temporary_password = ''
    6.times { |i| temporary_password << chars[rand(chars.size-1)] }
    temporary_password
  end

end
