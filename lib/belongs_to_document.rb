module BelongsToDocument
  def self.included(parent)
    parent.send :extend, BelongsToDocumentsClassMethods
  end

  module BelongsToDocumentsClassMethods
    
    def belongs_to_document(name)
      define_method(name) do
        name.to_s.singularize.classify.constantize.find(self.scenario_id)
      end
    end
    
  end
end
