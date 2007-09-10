# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ExceptionNotifiable

  class AccessDenied < StandardError; end

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_sourdough_session_id'

  before_filter :login_from_cookie

  around_filter :set_timezone, :catch_errors

  protected

  def self.protected_actions
    [ :edit, :update, :destroy ]
  end

  def check_auth
    unless current_user == @user or (logged_in? and current_user.admin?)
      raise AccessDenied
    end
  end

  def permission_denied
    flash[:notice] = "You don't have privileges to access that area"
    redirect_to '/'
  end

  private

  def set_timezone
    TzTime.zone = logged_in? ? current_user.tz : TimeZone.new('Pacific Time (US & Canada)')
    yield
    TzTime.reset!
  end

  def catch_errors
    begin
      yield

    rescue AccessDenied
      flash[:notice] = "You do not have access to that area."
      redirect_to '/'
    rescue ActiveRecord::RecordNotFound
      permission_denied
    end
  end

end
