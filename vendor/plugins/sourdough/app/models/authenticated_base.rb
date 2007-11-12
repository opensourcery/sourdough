# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
# Base authenticated class.  Inherit from this class, don't put any app-specific code in here.
# That way we can update this model if auth_generators update.

require 'digest/sha1'
module AuthenticatedBase
  def self.included(base)
    base.set_table_name base.name.tableize

    base.validates_presence_of     :login, :email
    base.validates_presence_of     :password,                   :if => :password_required?
    base.validates_presence_of     :password_confirmation,      :if => :password_required?
    base.validates_length_of       :password, :within => 4..40, :if => :password_required?
    base.validates_confirmation_of :password,                   :if => :password_required?
    base.validates_length_of       :login,    :within => 3..40
    base.validates_length_of       :email,    :within => 3..100
    base.validates_uniqueness_of   :login, :email, :case_sensitive => false
    base.before_save :encrypt_password
    base.before_create :make_activation_code

    base.cattr_accessor :current_user

    base.has_and_belongs_to_many :roles

    base.belongs_to :photo
    base.has_many :photos, :dependent => :destroy
    base.composed_of :tz, :class_name => 'TzinfoTimezone', :mapping => %w( time_zone time_zone )
    base.validates_format_of :login, :with => /^\w+$/
    base.validates_email_format_of :email
    # Protect internal methods from mass-update with update_attributes
    base.attr_accessible :login, :email, :password, :password_confirmation, :time_zone, :activated_at, :activation_code

    base.extend ClassMethods
  end

  attr_accessor :password

  module ClassMethods

    ## Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
    def authenticate(login, password)
      u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL and banned_at IS NULL', login] # need to get the salt
      u && u.authenticated?(password) ? u : nil
    end

    def activated?(login)
      u = find_by_login(login)
      u && u.activated_at
    end

    # Encrypts some data with the salt.
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end

    def find_by_param(*args)
      find_by_login *args
    end

  end

  def ban!
    self.banned_at = Time.now
    save!
  end

  def remove_ban!
    self.banned_at = nil
    save!
  end

  def to_xml
    super( :only => [ :login, :time_zone, :last_login_at ] )
  end

  def reset_password!
    temporary_password = create_temporary_password
    self.password, self.password_confirmation = temporary_password, temporary_password
    save!
  end

  def admin?
    roles.map{ |role| role.title}.include? 'admin'
  end

  def to_param
    login
  end

  # Activates the user in the database.
  def activate
    @activated = true
    self.attributes = {:activated_at => Time.now.utc, :activation_code => nil}
    save(false)
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
    self.last_login_at = Time.now
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

  private

  def create_temporary_password
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    temporary_password = ''
    6.times { |i| temporary_password << chars[rand(chars.size-1)] }
    temporary_password
  end

end
