# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")

require 'test_help'
require File.expand_path(File.dirname(__FILE__) + '/helper_testcase')

# Load the schema - if migrations have been performed, this will be up to date.
load(File.dirname(__FILE__) + "/../../../../db/schema.rb")

# set up the fixtures location
Test::Unit::TestCase.fixture_path = File.dirname(__FILE__)  + "/fixtures/"

$LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...
  include AuthenticatedTestHelper

  protected

  def create_user(options = {})
    post :create, :user => { :login => 'quire', :email => 'quire@example.com',
         :password => 'quire', :password_confirmation => 'quire'}.merge(options)
  end

  def update_user(login, options = {})
    post :update, :id => login, :user => { :login => 'quire', :email => 'quire@example.com',
         :password => 'quire', :password_confirmation => 'quire' }.merge(options)
  end

  def upload_file(options = {})
    post :create, :user_id => users(:quentin).login, :photo => {:uploaded_data => fixture_file_upload(options[:filename], options[:content_type])}, :html => { :multipart => true}
  end

end
