# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
module Administration #:nodoc:

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_administration
      before_filter  :login_required
      before_filter  :set_administration_area
      access_control :DEFAULT => 'admin'
      include Administration::InstanceMethods
      extend Administration::SingletonMethods
    end
  end

  module SingletonMethods
  end

  module InstanceMethods
    def set_administration_area
      @administration_area = true
    end
  end

end
