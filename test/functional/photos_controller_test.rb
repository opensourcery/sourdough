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
    #assert_redirected_to photos_path(users(:quentin))
    assert_valid assigns(:photo)
    assert_equal 'rails.png', assigns(:photo).filename
    assert_equal 2, Photo.count
    assert_equal 'rails.png', Photo.find(:all)[0].filename
    assert_equal 'rails_thumb.png', Photo.find(:all)[1].filename
  end

  def test_should_not_upload_file
    post 'create', :uploaded_data => 'test', :user_id => users(:quentin).login
    assert_template 'new'
  end

  def test_should_delete_photo
    assert_equal 1, Photo.count
    delete :destroy, :user_id => users(:quentin).login
    assert_equal 0, Photo.count
  end

  def should_display_upload
    get :new
    assert_response :success
  end

  protected

  def upload_file(options = {})
    post :create, :user_id => users(:quentin).login, :photo => {:uploaded_data => fixture_file_upload(options[:filename], options[:content_type])}, :html => { :multipart => true}
  end

end
