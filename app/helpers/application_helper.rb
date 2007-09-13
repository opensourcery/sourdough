module ApplicationHelper
  # Show the local time
  def tz(time_at)
    TzTime.zone.utc_to_local(time_at.utc)
  end

  def can_edit?
    if current_user == @user or (logged_in? and current_user.admin?)
      yield
    end
  end

  def avatar_for(user)
    if user.photo
      link_to_unless_current image_tag(user.photo.public_filename(:thumb)), user_path(user)
    else
      link_to_unless_current image_tag('no_photo_thumbnail.gif'), user_path(user)
    end
  end

  def sourdough_error_messages_for( *params )
    error_messages_for( params, :header_tag => 'h6', :class => 'flash' )
  end

  def administration_area_only
   if logged_in? and current_user.admin? and (!@administration_area.nil? and @administration_area == true)
     yield
   end
  end

  def in_administration_area?
    return true if logged_in? and current_user.admin? and (!@administration_area.nil? and @administration_area == true)
    return false
  end

  def new_photos_path( *user )
    return admin_new_photos_path(user) if in_administration_area?
    super
  end

  def photos_path( *user )
    return admin_photos_path(user) if in_administration_area?
    super
  end

  def home_path
    return admin_path if in_administration_area?
    super
  end

  def new_user_path( *user )
    return admin_new_user_path(user) if in_administration_area?
    super
  end

  def edit_user_path( *user )
    return admin_edit_user_path(user) if in_administration_area?
    super
  end

  def user_path( *user )
    return admin_user_path(user) if in_administration_area?
    super
  end

end
