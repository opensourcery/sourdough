require File.dirname(__FILE__) + '/../test_helper'
require 'admin_controller'

# Re-raise errors caught by the controller.
class AdminController; def rescue_action(e) raise e end; end

class AdminControllerTest < Test::Unit::TestCase

  fixtures :users, :roles, :roles_users

  def setup
    @controller = AdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_should_display_admin_page
    login_as(:quentin)
    get 'users'
    assert_template 'users'
  end

  def test_should_not_display_admin_page
    login_as(:aaron)
    get 'users'
    assert_redirected_to '/'
  end

end
