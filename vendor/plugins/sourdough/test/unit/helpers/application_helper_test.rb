# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
require File.dirname(__FILE__) + '/../../test_helper'

class ApplicationHelperTest < HelperTestCase

  include ApplicationHelper

  fixtures :users, :photos, :roles_users

  def setup
    super
  end

  def test_tz
    TzTime.zone = TimeZone.new('Pacific Time (US & Canada)')
    assert tz(Time.now)
  end

  def test_date
    assert date(Time.now)
  end

end
