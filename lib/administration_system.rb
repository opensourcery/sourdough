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
