class UsersController < ApplicationController

  @protected_actions = [ :edit, :update, :destroy ]
  before_filter :load_user, :except => [ :index, :create, :new, :activate ]
  before_filter :check_auth, :only => @protected_actions

  # GET /users/1
  # GET /users/1.xml
  def show
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @user.to_xml }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1;edit
  def edit
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.  Please check your email and activate your account.'
        UserMailer.deliver_signup_notification(@user, request.host_with_port + activate_path(@user.activation_code))
        format.html { redirect_to home_path }
        format.xml  { head :created, :location => home_path }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to edit_user_path(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end

  def activate
    self.current_user = User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.activated?
      current_user.activate
      UserMailer.deliver_activation(current_user, request.host_with_port + home_path)
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
  end

  protected
  def load_user
    @user = User.find_by_param(params[:id]) or raise ActiveRecord::RecordNotFound
  end

end
