class UserMailer < ActionMailer::Base

  cattr_accessor :from_address

  def forgotten_password(user, link, sent_at = Time.now)
    @subject     = 'Your new Pronetos password'
    @body        = { :user => user, :link => link }
    @recipients  = user.email
    @from        = from_address
    @sent_on     = sent_at
    @headers     = {}
  end

end
