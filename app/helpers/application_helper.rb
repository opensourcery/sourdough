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


end
