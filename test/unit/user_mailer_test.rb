require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  fixtures :users

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @request    = ActionController::TestRequest.new
    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
    @quentin = users(:quentin)
  end

  def test_forgotten_password
    @expected.body    = read_fixture('forgotten_password')
    @quentin.password = 'temporary'
    assert_equal @expected.body, UserMailer.create_forgotten_password(@quentin, "#{@request.host_with_port}/users/quentin;edit").body
  end

  def test_signup_notification
    @quentin.password = 'test'
    @quentin.activation_code = '123456'
    @expected.body    = read_fixture('signup_notification')
    assert_equal @expected.body, UserMailer.create_signup_notification(@quentin, "#{@request.host_with_port}/users/activate/123456").body
  end

  def test_activation_notification
    @expected.body    = read_fixture('activation')
    assert_equal @expected.body, UserMailer.create_activation(@quentin, @request.host_with_port).body
  end

  private

  def read_fixture(action)
    ERB.new(IO.readlines("#{FIXTURES_PATH}/user_mailer/#{action}").join).result
  end

  def encode(subject)
    quoted_printable(subject, CHARSET)
  end

end
