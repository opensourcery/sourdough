require "#{File.dirname(__FILE__)}/../test_helper"

class SpiderTest < ActionController::IntegrationTest
  fixtures :users

  include Caboose::SpiderIntegrator

  def test_spider_not_logged_in
    get '/'
    assert_response :success
    spider(@response.body, '/',
           :ignore_forms => [])
  end

  def test_spider_logged_in
    get '/session/new'
    assert_response :success
    post '/session/create', :login => 'quentin', :password => 'test'
    assert session[:user]
    assert_response :redirect
    assert_redirected_to '/'
    follow_redirect!
    spider(@response.body, '/',
           :ignore_urls  => [],
           :ignore_forms => [])
  end


end
