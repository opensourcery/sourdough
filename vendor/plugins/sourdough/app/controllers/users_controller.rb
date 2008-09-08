# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
class UsersController < ApplicationController

  @protected_actions = [ :edit, :update, :destroy ]
  before_filter :login_required, :except => [:new, :create, :activate, :show]
  before_filter :load_user, :except => [ :index, :create, :new, :activate ]
  before_filter :check_auth, :only => @protected_actions

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save and after_user_save
        format.html { redirect_to create_redirection_path }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to update_redirection_path(@user) }
      else
        format.html { render :action => update_render_action }
      end
    end
  end

  def activate
    self.current_user = User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.activated?
      current_user.activate
      UserMailer.deliver_activation(current_user, request.protocol + request.host_with_port + home_path)
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default(activation_redirection_path)
  end

  protected

  def after_user_save
    flash[:notice] = "Thank you for signing up!  We just sent you a confirmation email to #{@user.email}.  Please click on the activation link in the email to complete your sign up."
    UserMailer.deliver_signup_notification(@user, request.protocol + request.host_with_port + activate_path(@user.activation_code))
  end

  def load_user
   @user = User.find_by_param(params[:id]) or raise ActiveRecord::RecordNotFound
  end

  private

  def activation_redirection_path
    home_path
  end

  def update_redirection_path(user)
    edit_user_path(user)
  end

  def create_redirection_path
    login_path
  end

  def update_render_action
    "edit"
  end

end
