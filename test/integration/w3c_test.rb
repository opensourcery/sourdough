require "#{File.dirname(__FILE__)}/../test_helper"

class W3cTest < ActionController::IntegrationTest
  # fixtures :your, :models

  # Replace this with your real tests.
  def test_markup
    get '/'
    assert_valid_markup
  end
end
