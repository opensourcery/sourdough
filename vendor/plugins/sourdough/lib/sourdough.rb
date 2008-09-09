# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
# Sourdough
require_dependency 'open_sourcery/migration_helpers'
require_dependency 'administration/administration_system'
require_dependency 'authentication/authenticated_system'
require_dependency 'authentication/authenticated_test_helper'

# Specifies order to load fixtures to prevent foreign key problems
ENV['SOURDOUGH_FIXTURES'] ||= 'users'

ActionController::Base.send(:include, Administration)

ExceptionNotifier.exception_recipients = %w( alex@opensourcery.com )

module Sourdough
  mattr_accessor :from_address
  email_config = Hash.new
  yaml = YAML.load_file("#{RAILS_ROOT}/config/email.yml")
  yaml.each_pair {|k,v| email_config[k.to_sym] = v}
  self.from_address = email_config[:from_address]
end
