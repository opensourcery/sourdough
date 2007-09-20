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

  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to admin_users_url }
    end
  end

end
