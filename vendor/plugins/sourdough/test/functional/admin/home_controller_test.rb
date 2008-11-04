# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/home_controller'

# Re-raise errors caught by the controller.
class Admin::HomeController; def rescue_action(e) raise e end; end

class Admin::HomeControllerTest < Test::Unit::TestCase

  fixtures :users

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
