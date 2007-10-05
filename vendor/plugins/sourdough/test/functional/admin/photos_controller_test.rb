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

  def test_should_get_new
    get 'new', :user_id => users(:quentin).login
    assert_template 'new'
  end

  def test_should_upload_photo
    upload_file :filename => 'photos/rails.png', :content_type => 'image/png'
    assert_redirected_to new_admin_photos_path(users(:quentin))
    assert_valid assigns(:photo)
    assert_equal 'rails.png', assigns(:photo).filename
    assert_equal 2, Photo.count
    assert_equal 'rails.png', Photo.find(:all)[0].filename
    assert_equal 'rails_thumb.png', Photo.find(:all)[1].filename
  end

  def test_should_delete_photo
    assert_equal 1, Photo.count
    delete :destroy, :user_id => users(:quentin).login
    assert_equal 0, Photo.count
    assert_redirected_to new_admin_photos_path(users(:quentin))
  end

  def should_display_upload
    get :new
    assert_response :success
  end

  def test_should_find_controller_path
    assert_equal "photos", Admin::PhotosController.controller_path
  end

end
