require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/home_controller'

# Re-raise errors caught by the controller.
class Admin::HomeController; def rescue_action(e) raise e end; end

class Admin::HomeControllerTest < Test::Unit::TestCase

  fixtures :users, :roles, :roles_users

  def setup
    @controller = Admin::HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_display_home_page
    login_as(:quentin)
    get 'show'
    assert_response :success
    assert_template 'show'
  end

  def test_should_not_display_home_page
    login_as(:sam)
    get 'show'
    assert_response :redirect
  end

end
