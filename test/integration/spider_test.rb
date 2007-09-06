require "#{File.dirname(__FILE__)}/../test_helper"

class SpiderTest < ActionController::IntegrationTest
  fixtures :users

  include Caboose::SpiderIntegrator

  def test_spider
    get '/'
    assert_response :success

    spider(@response.body, '/')
  end

end
