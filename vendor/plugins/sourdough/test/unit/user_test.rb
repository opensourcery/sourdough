# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users, :roles, :roles_users

  def test_should_create_user
    user = create_user
    assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
  end

  def test_should_require_login
    u = create_user(:login => nil)
    assert u.errors.on(:login)
  end

  def test_should_require_password
    u = create_user(:password => nil)
    assert u.errors.on(:password)
  end

  def test_should_require_password_confirmation
    u = create_user(:password_confirmation => nil)
    assert u.errors.on(:password_confirmation)
  end

  def test_should_require_email
    u = create_user(:email => nil)
    assert u.errors.on(:email)
  end

  def test_should_not_rehash_password
    users(:quentin).update_attributes(:login => 'quentin2')
    assert_equal users(:quentin), User.authenticate('quentin2', 'test')
  end

  def test_should_authenticate_user
    assert_equal users(:quentin), User.authenticate('quentin', 'test')
  end

  def test_should_authenticate_user_with_email_address
    assert_equal users(:quentin), User.authenticate('quentin@example.com', 'test')
  end

  def test_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert_equal users(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_return_the_user_as_xml
    assert users(:quentin).to_xml
  end

  def test_should_not_allow_login_with_punctuation
    user = create_user(:login => 'quire.')
    assert user.errors.on(:login)
  end

  def test_should_reset_password
    old_password = users(:quentin).password
    users(:quentin).reset_password!
    assert_not_equal old_password, users(:quentin).password
  end

  def test_should_reset_password_of_an_invalid_user
    quentin = users(:quentin)
    old_password = quentin.password
    quentin.login = nil
    quentin.reset_password!
    assert_not_equal old_password, users(:quentin).password
  end

  def test_should_ban_user
    quentin = users(:quentin)
    quentin.ban!
    assert_not_nil quentin.banned_at
  end

  def test_should_ban_invalid_user
    quentin = users(:quentin)
    quentin.login = nil
    quentin.ban!
    assert_not_nil quentin.banned_at
  end

  def test_should_revoke_ban
    quentin = users(:quentin)
    banned = users(:banned)
    quentin.remove_ban!
    assert_nil quentin.banned_at
    assert_not_nil banned.banned_at
  end

  def test_should_revoke_ban_on_invalid_user
    quentin = users(:quentin)
    banned = users(:banned)
    quentin.login = nil
    quentin.remove_ban!
    assert_nil quentin.banned_at
    assert_not_nil banned.banned_at
  end

  def test_should_activate_a_user
    not_activated = users(:not_activated)
    not_activated.activate
    assert_not_nil not_activated.activated_at
    assert_nil not_activated.activation_code
  end

  def test_should_turn_a_user_into_an_admin
    sam = users(:sam)
    aaron = users(:aaron)
    assert_equal false, sam.admin?
    sam.make_admin!
    assert_equal true, sam.admin?
    assert_equal false, aaron.admin?
  end
  
  def test_should_revoke_admin_from_a_user
    sam = users(:sam)
    quentin = users(:quentin)
    sam.make_admin!
    assert_equal true, sam.admin?
    sam.revoke_admin!
    assert_equal false, sam.admin?
    assert_equal true, quentin.admin?
  end

  protected
    def create_user(options = {})
      User.create({ :login => 'quire', :email => 'quire@example.com',
                    :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
end
