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
    update_user('aaron', :email => 'updated@email.com')
    assert assigns(:user)
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

  def test_should_destroy_user
    login_as(:quentin)
    delete 'destroy', :id => 'aaron'
    assert_redirected_to 'admin/users'
  end

  def test_should_not_find_user
    get 'show', :id => 'nobody'
    assert_equal "That item does not exist", flash[:notice]
    assert_redirected_to '/'
  end

  protected

  def create_user(options = {})
    post :create, :user => { :login => 'quire', :email => 'quire@example.com',
         :password => 'quire', :password_confirmation => 'quire' }.merge(options)
  end

  def update_user(login, options = {})
    post :update, :id => login, :user => { :login => 'quire', :email => 'quire@example.com',
         :password => 'quire', :password_confirmation => 'quire' }.merge(options)
  end

end
