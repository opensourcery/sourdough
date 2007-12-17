# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
require File.dirname(__FILE__) + '/../test_helper'

class SpiderTest < ActionController::IntegrationTest
  fixtures :users, :photos, :roles

  include Caboose::SpiderIntegrator

  def test_spider_not_logged_in
    get '/'
    assert_response :success
    spider(@response.body, '/',
           :verbose => false,
           :ignore_urls  => [%r{^.+prefect.opensourcery.com.?}],
           :ignore_forms => [%r{}])
  end

  def test_spider_logged_in
    get '/sessions/new'
    assert_response :success
    post '/sessions/create', :login => 'quentin', :password => 'test'
    assert session[:user]
    assert_response :redirect
    assert_redirected_to '/'
    follow_redirect!
    spider(@response.body, '/',
           :verbose => false,
           :ignore_urls  => [%r{^.+prefect.opensourcery.com.?}],
           :ignore_forms => [%r{}])
  end


end
