# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env["HTTP_REFERER"] = '/profile/quentin'
  end

  def test_should_allow_signup
    assert_difference User, :count do
      create_user
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference User, :count do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference User, :count do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference User, :count do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference User, :count do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end

  def test_should_update_user
    login_as(:aaron)
    update_user('aaron', :email => 'updated@email.com', :login => 'aaron')
    assert assigns(:user)
    assert_redirected_to edit_user_path(User.find_by_login('aaron'))
  end

  def test_should_not_update_user_because_of_missing_login
    login_as(:aaron)
    update_user('aaron', :email => '')
    assert_template 'edit'
  end

  def test_should_not_update_user_because_of_bad_permissions
    login_as(:aaron)
    update_user('quentin', :email => 'updated@email.com')
    assert_equal "You don't have privileges to access that area", flash[:notice]
    assert_redirected_to '/'
  end

  def test_should_update_user_because_they_are_admin
    login_as(:quentin)
    update_user('aaron', :email => 'updated@email.com')
    assert assigns(:user)
  end

  def test_should_display_user
    login_as(:quentin)
    get 'show', :id => 'quentin'
    assert_response :success
    assert_template 'show'
  end

  def test_should_display_user_without_avatar
    get 'show', :id => 'aaron'
    assert_response :success
    assert_template 'show'
  end

  def test_should_not_find_user
    get 'show', :id => 'nobody'
    assert_equal "That item does not exist", flash[:notice]
    assert_redirected_to '/'
  end

  def test_should_activate_user
    get :activate, :activation_code => users(:aaron).activation_code
    assert_redirected_to '/'
    assert_equal "Signup complete!", flash[:notice]
    assert_equal users(:aaron), User.authenticate('aaron', 'test')
  end

end
