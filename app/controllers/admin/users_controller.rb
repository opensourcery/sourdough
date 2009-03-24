# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
class Admin::UsersController < UsersController

  acts_as_administration
  before_filter :list_users, :only => [:index, :show]

  def ban
    @user.ban!
    redirect_to admin_user_path(@user)
  end

  def remove_ban
    @user.remove_ban!
    redirect_to admin_user_path(@user)
  end

  def make_admin
    @user.make_admin!
    flash[:notice] = "#{@user.login} has been made an administrator"
    redirect_to admin_user_path(@user)
  end

  def revoke_admin
    @user.revoke_admin!
    flash[:notice] = "#{@user.login} is no longer an administrator"
    redirect_to admin_user_path(@user)
  end

  def admin_activate
    @user.activate
    flash[:notice] = "#{@user.login} has been successfully activated"
    redirect_to admin_user_path(@user)
  end

  def admin_reset_password
    @user.reset_password!
    UserMailer.deliver_forgotten_password(@user, request.protocol + request.host_with_port)
    flash[:notice] = "#{@user.login} has been mailed a new password"
    redirect_to admin_user_path(@user)
  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'[:user_updated]
        format.html { redirect_to admin_user_path(@user) }
      else
        format.html { render :action => 'show' }
      end
    end
  end

  protected

  def list_users
    @users = User.find(:all, :order => 'email asc')
  end
end
