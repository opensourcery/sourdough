# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
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
    login_as(:quentin)
  end

  def test_should_find_controller_path
    assert_equal "photos", Admin::PhotosController.controller_path
  end

end
