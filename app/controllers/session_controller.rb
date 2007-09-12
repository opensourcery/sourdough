# This controller handles the login/logout function of the site.
class SessionController < ApplicationController

  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default('/')
    else
      flash.now[:error] = "Login failed.  Are you sure your username and password are correct?"
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to :action => :new
  end

  def reset_password
    if @user = User.find_by_email(params[:email])
      flash[:notice] = "A temporary password has been sent to '#{CGI.escapeHTML @user.email}'"
      @user.reset_password!
      UserMailer.deliver_forgotten_password(@user, edit_user_path(@user))
      redirect_to login_path
    else
      flash[:error] = "I could not find an account with the email address #{CGI.escapeHTML params[:email]}. Did you type it correctly?"
      redirect_to forgotten_password_session_path
    end
  end

  def forgotten_password
  end

end
