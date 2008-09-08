# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
require File.dirname(__FILE__) + '/../test_helper'
require 'photos_controller'

# Re-raise errors caught by the controller.
class PhotosController; def rescue_action(e) raise e end; end

class PhotosControllerTest < Test::Unit::TestCase

  fixtures :users, :photos

  def setup
    @controller = PhotosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as :quentin
  end

  def test_should_find_rmagick
    assert require('RMagick')
  end

  def test_should_get_new
    get 'new', :user_id => users(:quentin).login
    assert_template 'new'
  end

  def test_should_upload_photo
    upload_file :filename => 'photos/rails.png', :content_type => 'image/png'
    assert_redirected_to new_user_photos_path(users(:quentin))
  end

  def test_should_delete_photo
    delete :destroy, :user_id => users(:quentin).login
    assert_redirected_to new_user_photos_path(users(:quentin))
  end

  def should_display_upload
    get :new
    assert_response :success
  end

end
