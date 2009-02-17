require 'rubygems'
require 'active_record'

module ModelFactory
  def next_local_id # :nodoc:
    @max_id ||= 0
    return @max_id += 1
  end

  #
  # When specifying defaults, you should only provide only enough data that
  # the created instance is valid. If you want to include another factory
  # object as a dependency use the special method default_* instead of
  # create_* or new_*.
  #
  def default(class_type, *args)
    defaults   = args.pop || {}
    prefix     = args.first
    class_name = class_type.name.demodulize.underscore
    class_name = "#{prefix}_#{class_name}" if prefix

    (class << self; self; end).module_eval do
      define_method "create_#{class_name}" do |*args|
        attributes = args.first || {}
        create_instance(class_type, attributes, defaults)
      end
    
      define_method "new_#{class_name}" do |*args|
        attributes = args.first || {}
        new_instance(class_type, attributes, defaults)
      end

      define_method "default_#{class_name}" do |*args|
        attributes = args.first || {}
        default_closure(class_type, attributes, defaults)
      end
    end
  end
    
  def create_instance(class_type, attributes, defaults = {}) # :nodoc:
    attributes = instantiate_defaults(:create, defaults.merge(attributes))
    instance = class_type.create!(attributes)
    if update_protected_attributes(instance, attributes)
      instance.save
    end
    instance
  end
  
  def new_instance(class_type, attributes, defaults = {}) # :nodoc:
    attributes = instantiate_defaults(:new, defaults.merge(attributes))
    instance = class_type.new(attributes)
    instance.id = next_local_id
    update_protected_attributes(instance, attributes)
    instance
  end

  def default_closure(class_type, attributes, defaults = {}) # :nodoc:
    lambda do |create_or_new|
      case create_or_new
      when :new    : new_instance(class_type, attributes, defaults)
      when :create : create_instance(class_type, attributes, defaults)
      end
    end
  end
  
  def instantiate_defaults(create_or_new, attributes) # :nodoc:
    attributes.each do |key, value|
      if value.is_a?(Proc)
        attributes[key] = value.arity == 0 ? value.call : value.call(create_or_new)
      end
    end
    attributes
  end

  def update_protected_attributes(instance, attributes) # :nodoc:
    modified = false
    protected_attrs  = instance.class.protected_attributes
    protected_attrs  = protected_attrs.to_set if protected_attrs
    accessible_attrs = instance.class.accessible_attributes
    accessible_attrs = accessible_attrs.to_set if accessible_attrs

    if protected_attrs or accessible_attrs
      attributes.each do |key, value|
        # Support symbols and strings.
        next if protected_attrs  and not (protected_attrs.include?(key) or protected_attrs.include?(key.to_s))
        next if accessible_attrs and (accessible_attrs.include?(key) or accessible_attrs.include?(key.to_s))
        modified = true
        instance.send("#{key}=", value)
      end
    end
    return modified
  end

  # Any class methods of the form "new_some_type(attrs)" or "create_some_type(attrs)" will be converted to
  # "SomeType.new(attrs)" and "SomeType.create!(attrs)" respectively.
  # These basically function as though you'd used the 'default' directive with empty defaults.
  def method_missing(missing_method, attributes = {})
    if missing_method.to_s.match(/^(new|create|default)_([a-z][\w_]+)$/)
      method, class_name = $1, $2
      class_type = class_name.camelize.constantize
      case method
      when 'create'
        create_instance(class_type, attributes)
      when 'new'
        new_instance(class_type, attributes)
      when 'default'
        default_closure(class_type, attributes)
      end
    else
      raise NoMethodError, "no such method '#{missing_method}'"
    end
  end
end
