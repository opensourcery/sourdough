# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
require File.dirname(__FILE__) + '/../test_helper'

class ApplicationControllerTest < Test::Unit::TestCase

  def test_find_all_todos_and_fixmes
    message = ''
    Dir['app/**/*'].each do |path|
      if FileTest.file? path
        File.open( path ) do |f|
          f.grep( /TODO|FIXME/ ) do |line|
            message += path +  ':' + line
          end
        end
      end
    end
    flunk(message) if message.size > 0
  end

end
