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
