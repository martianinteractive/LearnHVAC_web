module Mongoid
  module Document
    module Taggable
      def self.included(base)
        base.class_eval do |base1|
          base1.field :tags, :type => Array          
 
          include InstanceMethods
          extend ClassMethods
        end
      end
      
      module InstanceMethods
        def tag_list=(tags)
          self.tags = tags.split(",").collect{|t| t.strip}
        end

        def tag_list
          self.tags.join(", ") if tags
        end
      end
 
      module ClassMethods
        def tags
          all.collect{ |ms| ms.tags }.flatten.uniq.compact
        end

        def tagged_with(_tags)
          _tags = [_tags] unless _tags.is_a? Array
          criteria.in(:tags => _tags)
        end
      end
      
    end
  end
end