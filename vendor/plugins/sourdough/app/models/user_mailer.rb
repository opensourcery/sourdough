# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
class UserMailer < ActionMailer::Base

  def signup_notification(user, url)
    setup_email(user)
    @subject    += "Please activate your new #{'Sourdough'[]} account"
    @body[:url]  = url
  end

  def activation(user, url)
    setup_email(user)
    @subject    += "Your #{'Sourdough'[]} account has been activated!"
    @body[:url]  = url
  end

  def forgotten_password(user, url)
    setup_email(user)
    @subject     += "Your new #{'Sourdough'[]} password"
    @body[:url]  = url
  end

  protected

  def setup_email(user)
    @recipients  = user.email
    @from        = Sourdough.from_address
    @subject     = ""
    @sent_on     = Time.now
    @body[:user] = user
  end

end
