class UserMailer < ActionMailer::Base

  cattr_accessor :from_address

  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new #{Sourdough[]} account'
    @body[:url]  = "http://YOURSITE/activate/#{user.activation_code}"
  end

  def activation(user)
    setup_email(user)
    @subject    += 'Your #{Sourdough[]} account has been activated!'
    @body[:url]  = "http://YOURSITE/"
  end

  def forgotten_password(user, link)
    setup_email(user)
    @subject     += 'Your new #{Sourdough[]} password'
    @body[:url]  = link
  end

  protected

  def setup_email(user)
    @recipients  = user.email
    @from        = from_address
    @subject     = ""
    @sent_on     = Time.now
    @body[:user] = user
  end

end
