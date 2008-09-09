# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ExceptionNotifiable
  include ApplicationHelper

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_sourdough_session_id', :secret => 'Shoow2Qu thae2eeJ uiri7OoH Chu5shoz oom6Phei ithier5P Oohei7Ee naesh8Xe'

  before_filter :login_from_cookie, :set_timezone
  filter_parameter_logging "password"

  protected

  def check_auth
    unless current_user == @user or (logged_in? and current_user.is_admin?)
      permission_denied
    end
  end

  def find_user
    id = params[:user_id] ? params[:user_id] : params[:id]
    @user = User.find_by_param(id) or raise ActiveRecord::RecordNotFound
  end

  def permission_denied
    flash[:notice] = "You don't have privileges to access that area"
    access_denied
  end

  def set_administration_area
    @administration_area = true
  end

  private

  def set_timezone
    Time.zone = current_user.time_zone if logged_in?
  end

end

