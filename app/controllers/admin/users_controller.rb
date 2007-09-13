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
