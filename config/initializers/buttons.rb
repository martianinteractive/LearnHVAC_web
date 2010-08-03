module Buttons
  module ControllerMethods
    module ClassMethods
      def subject_buttons(name, *args)
        options = args.extract_options!
        before_filter(options) do |instance|
          instance.subject_buttons(name)
        end
      end
    end

    module InstanceMethods
      def subject_buttons(name)
        get_or_set_ivar "@subject_buttons", name
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

ActionController::Base.send :include, Buttons::ControllerMethods