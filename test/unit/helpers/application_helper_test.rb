require File.dirname(__FILE__) + '/../../test_helper'

class ApplicationHelperTest < HelperTestCase

  include ApplicationHelper

  fixtures :users, :photos

  def setup
    super
  end

  def test_avatar_for_quentin
    output = avatar_for(users(:quentin))
    assert_match %r{<a href="/users/quentin"><img alt="Test_thumb" src="/photos/0000/0001/test_thumb.gif?.*" /></a>}, output
  end

  def test_avatar_for_aaron
    output = avatar_for(users(:aaron))
    assert_match %r{<a href="/users/aaron"><img alt="No_photo_thumbnail" src="/images/no_photo_thumbnail.gif?.*" /></a>}, output
  end

end
