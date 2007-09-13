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
        format.html { redirect_to user_url(@user) }
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
      format.html { redirect_to user_url(@user) }
    end
  end

  protected

  def load_user
    @user = User.find_by_param(params[:user_id]) or raise ActiveRecord::RecordNotFound
  end

end
