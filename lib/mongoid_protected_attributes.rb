module Mongoid
  module Document
    module ProtectedAttributes
      def self.included(base)
        base.class_eval do |base1|
 
          @@protected_attributes = []
 
          include InstanceMethods
          extend ClassMethods
        end
      end
      
      module InstanceMethods
        
        def write_attributes(attrs = nil)
          attrs = attrs.reject {|k,v| (self.class.protected_attribute.include?(k.to_s))}
          process(attrs || {})
          identify if id.blank?
          notify
        end
        
      end
 
      module ClassMethods
        # Define protected attributes
        def attr_protected(*attributes)
          @@protected_attributes = attributes.collect(&:to_s)
        end
 
        def protected_attributes
          @@protected_attributes
        end
      end
      
    end
  end
end