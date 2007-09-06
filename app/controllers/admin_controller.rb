class AdminController < ApplicationController

  before_filter :login_required
  access_control :index => 'admin'

  def users
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @users.to_xml }
    end
  end

end
