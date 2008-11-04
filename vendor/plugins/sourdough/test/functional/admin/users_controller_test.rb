# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/users_controller'

# Re-raise errors caught by the controller.
class Admin::UsersController; def rescue_action(e) raise e end; end

class Admin::UsersControllerTest < Test::Unit::TestCase

  fixtures :users

  def setup
    @controller = Admin::UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_not_ban_user
    login_as(:sam)
    delete 'ban', :id => users(:aaron).to_param
    assert_equal "You don't have privileges to access that area", flash[:notice]
  end

  def test_should_ban_user
    login_as(:quentin)
    delete 'ban', :id => users(:aaron).to_param
    assert_redirected_to admin_user_path(users(:aaron))
  end

  def test_should_activate_user
    login_as(:quentin)
    post 'admin_activate', :id => users(:aaron).to_param

    assert_redirected_to admin_user_path(users(:aaron))
  end

  def test_should_activate_user
    login_as(:quentin)
    post 'admin_activate', :id => users(:aaron).to_param
    assert_redirected_to admin_user_path(users(:aaron))
    assert_not_nil User.find_by_login('aaron').activated_at
  end

  def test_should_reset_password
    login_as(:quentin)
    post 'admin_reset_password', :id => users(:aaron).to_param
    assert_redirected_to admin_user_path(users(:aaron))
  end

  def test_should_update_user
    login_as(:quentin)
    update_user(users(:aaron).to_param, :login => 'aaron', :email => 'updated@email.com')
    assert assigns(:user)
    assert_redirected_to admin_user_path(users(:aaron))
  end

  def test_should_not_update_user_because_of_bad_permissions
    login_as(:aaron)
    update_user(users(:quentin), :email => 'updated@email.com')
    assert_equal "You don't have privileges to access that area", flash[:notice]
  end

  def test_should_display_user
    login_as(:quentin)
    User.find(:all).each do |user|
      get 'show', :id => user.to_param
      assert_response :success
      assert_template 'show'
    end
  end

  def test_should_make_user_an_admin
    login_as(:quentin)
    User.find(:all).each do |user|
      post 'make_admin', :id => user.to_param
      assert_redirected_to admin_user_path(user.to_param)
    end
  end

  def test_should_revoke_an_admin
    login_as(:quentin)
    User.find(:all).each do |user|
      post 'revoke_admin', :id => user.to_param
      assert_redirected_to admin_user_path(user.to_param)
    end
  end

  def test_should_look_at_index
    login_as(:quentin)
    get :index
    assert_response :success
  end
  
end
