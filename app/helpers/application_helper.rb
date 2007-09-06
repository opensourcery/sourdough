module ApplicationHelper

  # Show the local time
  def tz(time_at)
    TzTime.zone.utc_to_local(time_at.utc)
  end

  def can_edit?
    if current_user == @user or current_user.admin?
      yield
    end
  end

end
