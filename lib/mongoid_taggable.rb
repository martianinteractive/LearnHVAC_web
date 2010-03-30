module Mongoid
  module Document
    module Taggable
      def self.included(base)
        base.class_eval do |base1|
          base1.field :tags, :type => Array    
          base1.index :tags      
 
          include InstanceMethods
          extend ClassMethods
        end
      end
      
      module InstanceMethods
        def tag_list=(tags)
          self.tags = tags.split(",").collect{ |t| t.strip }.delete_if{ |t| t.blank? }
        end

        def tag_list
          self.tags.join(", ") if tags
        end
      end
 
      module ClassMethods
        def tags
          all.only(:tags).collect{ |ms| ms.tags }.flatten.uniq.compact
        end
        
        # I have to figure out how to make this with something similar to "LIKE"
        def tagged_like(_perm)
          _tags = tags
          _tags.delete_if { |t| !t.include?(_perm) }
        end
        
        def tagged_with(_tags)
          _tags = [_tags] unless _tags.is_a? Array
          criteria.in(:tags => _tags)
        end
      end
      
    end
  end
end