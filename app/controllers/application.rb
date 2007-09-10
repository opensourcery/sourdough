# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ExceptionNotifiable

  class AccessDenied < StandardError; end

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_trunk_session_id'

  # If you want timezones per-user, uncomment this:
  #before_filter :login_required

  around_filter :set_timezone

  protected

  def self.protected_actions
    [ :edit, :update, :destroy ]
  end

  def check_auth
    unless current_user == @user or (logged_in? and current_user.admin?)
      raise AccessDenied
    end
  end

  private

  def set_timezone
    TzTime.zone = logged_in? ? current_user.tz : TimeZone.new('Pacific Time (US & Canada)')
    yield
    TzTime.reset!
  end

end
