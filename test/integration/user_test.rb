require "#{File.dirname(__FILE__)}/../test_helper"

class UserTest < ActionController::IntegrationTest
  fixtures :users, :roles, :roles_users

  # Replace this with your real tests.
  def test_sign_up_and_log_in
    go_home

    get login_path
    assert_response :success
    assert_template "session/new"

    get signup_path
    assert_response :success
    assert_template "users/new"

    # create an account
    post users_path, :user => {  :login => "alexkroman", :password => "sourdough", :password_confirmation => "sourdough", :email => "alex@opensourcery.com" }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template "home/index"

    # sign in?
    post session_path, :login => 'alexkroman', :password => '123456'
    assert_response :success # not activated yet
    assert_template "session/new"

    # activate
    go_home
    user = User.find_by_login('alexkroman')
    get activate_path(user.activation_code)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template "home/index"

    # login
    post session_path, :login => 'alexkroman', :password => 'sourdough'
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template "home/index"

    # look at user page
    get edit_user_path(user)
    assert_response :success

    get new_photos_path(user)
    assert_response :success

    get logout_path
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template "session/new"

  end

  def test_user_admin_area
    # sign in?
    post session_path, :login => 'quentin', :password => 'test'
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template "home/index"

    get admin_path
    assert_response :success

    get admin_users_path
    assert_response :success

  end

  def test_try_to_break_into_admin_area
    # sign in?
    get admin_path
    assert_response :redirect

    get admin_users_path
    assert_response :redirect

    get admin_user_path(users(:quentin))
    assert_response :redirect

    get admin_photos_path(users(:quentin))
    assert_response :redirect

  end

  private

  def go_home
    get home_path
    assert_response :success
    assert_template 'home/index'
  end

end

