# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
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
    validates_presence_of     :login, :if => :using_login?
    validates_length_of       :login,    :within => 3..40, :if => :using_login?
    validates_uniqueness_of   :login, :case_sensitive => false, :if => :using_login?
    validates_uniqueness_of   :email, :case_sensitive => false
    validates_format_of       :login, :with => /^\w+$/, :if => :using_login?
    validates_length_of       :email,    :within => 3..100
    validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create, :message=>"Invalid email address."
    validates_presence_of     :password,                   :if => :password_required?
    validates_presence_of     :password_confirmation,      :if => :password_required?
    validates_length_of       :password, :within => 4..40, :if => :password_required?
    validates_confirmation_of :password,                   :if => :password_required?
    file_column :image, :magick => {
        :versions => {
        :square => {:crop => "1:1", :size => "50x50", :name => "square"},
        :small => "175x250>"
      }
    }
    before_save :encrypt_password
    before_create :make_activation_code

    cattr_accessor :current_user

    # Protect internal methods from mass-update with update_attributes
    attr_accessor :password

    ## Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
    def self.authenticate(login, password)
      u = find :first, :conditions => ['(lower(login) = ? or lower(email) = ?) and activated_at IS NOT NULL and banned_at IS NULL', login.downcase, login.downcase] # need to get the salt
      u && u.authenticated?(password) ? u : nil
    end

    # Encrypts some data with the salt.
    def self.encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end

    def self.find_by_param(*args)
      find_by_login *args
    end

    def ban!
      self.banned_at = Time.now
      save_with_validation(false)
    end

    def remove_ban!
      self.banned_at = nil
      save_with_validation(false)
    end

    def make_admin!
      self.is_admin = true
      self.save!
    end

    def revoke_admin!
      self.is_admin = false
      self.save!
    end

    def to_xml
      super( :only => [ :login, :time_zone, :last_login_at ] )
    end

    def reset_password!
      temporary_password = create_temporary_password
      self.password, self.password_confirmation = temporary_password, temporary_password
      save_with_validation(false)
    end

    def to_param
      login
    end

    # Activates the user in the database.
    def activate
      @activated = true
      self.activated_at = Time.now
      self.activation_code = nil
      self.save!
    end

    def activated?
      !! activation_code.nil?
    end

    # Encrypts the password with the user salt
    def encrypt(password)
      self.class.encrypt(password, salt)
    end

    def authenticated?(password)
      crypted_password == encrypt(password)
    end

    def remember_token?
      remember_token_expires_at && Time.now.utc < remember_token_expires_at
    end

    # These create and unset the fields required for remembering users between browser closes
    def remember_me
      remember_me_for 2.weeks
    end

    def remember_me_for(time)
      remember_me_until time.from_now.utc
    end

    # Useful place to put the login methods
    def remember_me_until(time)
      self.visits_count = visits_count.to_i + 1
      self.last_login_at = Time.now.utc
      self.remember_token_expires_at = time
      self.remember_token = encrypt("#{email}--#{remember_token_expires_at}")
      save(false)
    end

    def forget_me
      self.remember_token_expires_at = nil
      self.remember_token            = nil
      save(false)
    end

    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end

    def password_required?
      (crypted_password.blank? || !password.blank?)
    end

    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end

    def status
      return 'Admin' if is_admin?
      return 'Not Activated' if activation_code?
      return 'Banned' if banned_at?
      return 'Active'
    end

    private

    def using_login?
      true
    end

    def create_temporary_password
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      temporary_password = ''
      6.times { |i| temporary_password << chars[rand(chars.size-1)] }
      temporary_password
    end

end
