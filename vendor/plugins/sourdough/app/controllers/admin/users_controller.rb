# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
class Admin::UsersController < UsersController

  acts_as_administration

  def self.controller_path
    UsersController.controller_path
  end

  def index
    @users = User.find(:all)
    render :file => 'admin/users/index', :use_full_path => true, :layout => true
  end

  def ban
    @user.ban!
    redirect_to admin_users_path
  end

  def remove_ban
    @user.remove_ban!
    redirect_to admin_users_path
  end

  def admin_activate
    @user.activate
    flash[:notice] = "#{@user.login} has been successfully activated"
    redirect_to admin_users_path
  end

  def admin_reset_password
    @user.reset_password!
    UserMailer.deliver_forgotten_password(@user, request.protocol + request.host_with_port)
    flash[:notice] = "#{@user.login} has been mailed a new password"
    redirect_to admin_users_path
  end

end
