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
  end

  def test_forgotten_password
    @expected.subject = 'Your new Pronetos password'
    @expected.body    = read_fixture('forgotten_password')
    @expected.date    = Time.now
    quentin = users(:quentin)
    quentin.password = 'temporary'
    assert_equal @expected.body, UserMailer.create_forgotten_password(quentin, @request.host_with_port, @expected.date).body
  end

  private

  def read_fixture(action)
    ERB.new(IO.readlines("#{FIXTURES_PATH}/user_mailer/#{action}").join).result
  end

  def encode(subject)
    quoted_printable(subject, CHARSET)
  end

end
