# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
module ApplicationHelper

  def can_edit?( model = nil )
    owner = @user || (model.user unless model.nil?)
    if current_user == owner or (logged_in? and current_user.is_admin?)
      yield
    end
  end

  def avatar_for(user)
    if user.image
      link_to_unless_current image_tag(url_for_file_column(user, "image", "square"))
    else
      link_to_unless_current image_tag('no_photo_thumbnail.gif', :plugin => 'sourdough'), user_path(user)
    end
  end

  def sourdough_error_messages_for( *params )
    error_messages_for( params, :header_tag => 'h6', :class => 'flash' )
  end

  def administration_area_only
   if logged_in? and current_user.is_admin? and (!@administration_area.nil? and @administration_area == true)
     yield
   end
  end

  def in_administration_area?
    return true if logged_in? and current_user.is_admin? and (!@administration_area.nil? and @administration_area == true)
    return false
  end

  def new_user_photos_path(user)
    return new_admin_photos_path(user) if in_administration_area?
    super
  end

  def user_photos_path(user)
    return admin_photos_path(user) if in_administration_area?
    super
  end

  def home_path
    return admin_path if in_administration_area?
    super
  end

  def new_user_path
    return new_admin_user_path if in_administration_area?
    super
  end

  def edit_user_path(user)
    return edit_admin_user_path(user) if in_administration_area?
    super
  end

  def user_path(user)
    return admin_user_path(user) if in_administration_area?
    super
  end

  def users_path
    return admin_users_path if in_administration_area?
    super
  end

  def date(value)
    value.strftime('%B %d, %Y') if value
  end

end
