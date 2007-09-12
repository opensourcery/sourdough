class UserMailer < ActionMailer::Base

  cattr_accessor :from_address

  def signup_notification(user, url)
    setup_email(user)
    @subject    += 'Please activate your new #{Sourdough[]} account'
    @body[:url]  = url
  end

  def activation(user, url)
    setup_email(user)
    @subject    += 'Your #{Sourdough[]} account has been activated!'
    @body[:url]  = url
  end

  def forgotten_password(user, url)
    setup_email(user)
    @subject     += 'Your new #{Sourdough[]} password'
    @body[:url]  = url
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
