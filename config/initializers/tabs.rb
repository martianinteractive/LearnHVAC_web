module Tabs
  module ControllerMethods
    module ClassMethods
      def inner_tabs(name, *args)
        options = args.extract_options!
        before_filter(options) do |instance|
          instance.inner_tabs(name)
        end
      end
    end

    module InstanceMethods
      def inner_tabs(name)
        get_or_set_ivar "@inner_tabs", name
      end

      def get_or_set_ivar(var, value) # :nodoc:
        instance_variable_set var, instance_variable_get(var) || value
      end
      private :get_or_set_ivar
    end

    def self.included(receiver) # :nodoc:
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
  
end

ActionController::Base.send :include, Tabs::ControllerMethods