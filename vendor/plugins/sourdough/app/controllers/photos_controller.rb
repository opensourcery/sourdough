# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
class PhotosController < ApplicationController

  before_filter :login_required, :load_user, :check_auth

  def new
  end

  def create
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your photo has been uploaded.'
        format.html { redirect_to create_redirection_path}
      else
        format.html { render :action => "new" }
      end
    end
  end

  def destroy
    @user.image = nil

    respond_to do |format|
      if @user.save
        flash[:notice] = 'Your photo has been deleted'
        format.html { redirect_to destroy_redirection_path }
      else
        format.html { render :action => "new" }
      end
    end
  end

  protected

  def load_user
    @user = User.find_by_param(params[:user_id]) or raise ActiveRecord::RecordNotFound
  end

  private

  def create_redirection_path
    new_user_photos_path(@user)
  end

  def destroy_redirection_path
    new_user_photos_path(@user)
  end

end
