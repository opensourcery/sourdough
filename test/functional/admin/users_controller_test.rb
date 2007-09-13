require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/users_controller'

# Re-raise errors caught by the controller.
class Admin::UsersController; def rescue_action(e) raise e end; end

class Admin::UsersControllerTest < Test::Unit::TestCase

  fixtures :users, :roles, :roles_users

  def setup
    @controller = Admin::UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_not_destroy_user
    login_as(:sam)
    delete 'destroy', :id => 'aaron'
    assert_redirected_to home_path
  end

  def test_should_destroy_user
    login_as(:quentin)
    delete 'destroy', :id => 'aaron'
    assert_redirected_to 'admin/users'
  end

end
