# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ExceptionNotifiable
  include ApplicationHelper

  class AccessDenied < StandardError; end

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_sourdough_session_id', :secret => 'Shoow2Qu thae2eeJ uiri7OoH Chu5shoz oom6Phei ithier5P Oohei7Ee naesh8Xe'

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
