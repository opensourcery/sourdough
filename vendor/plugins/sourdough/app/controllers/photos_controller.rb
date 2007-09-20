# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
class PhotosController < ApplicationController

  before_filter :login_required, :load_user, :check_auth

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(params[:photo])
    @photo.user = @user
    @user.photo.destroy if @user.photo
    @user.photo = @photo

    respond_to do |format|
      if @photo.valid? and @user.valid? and @user.save
        flash[:notice] = 'Your photo has been uploaded.'
        format.html { redirect_to create_redirection_path}
      else
        format.html { render :action => "new" }
      end
    end
  end

  def destroy
    @photo = @user.photo
    @photo.destroy

    respond_to do |format|
      flash[:notice] = 'Your photo has been deleted'
      format.html { redirect_to destroy_redirection_path }
    end
  end

  protected

  def load_user
    @user = User.find_by_param(params[:user_id]) or raise ActiveRecord::RecordNotFound
  end

  private

  def create_redirection_path
    new_photos_path(@user)
  end

  def destroy_redirection_path
    new_photos_path(@user)
  end

end
