require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/photos_controller'

# Re-raise errors caught by the controller.
class Admin::PhotosController; def rescue_action(e) raise e end; end

class Admin::PhotosControllerTest < Test::Unit::TestCase

  fixtures :users, :roles, :roles_users, :photos

  def setup
    @controller = Admin::PhotosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
