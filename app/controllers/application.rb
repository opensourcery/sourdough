# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ExceptionNotifiable
  include ApplicationHelper

  class AccessDenied < StandardError; end

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_sourdough_session_id'

  before_filter :login_from_cookie

  around_filter :set_timezone, :catch_errors

  protected

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
      permission_denied
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "That item does not exist"
      redirect_to '/'
    end
  end

end
