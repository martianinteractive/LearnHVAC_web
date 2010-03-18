# Adds the has_many_documents relationship.
# Adds Basic finders => 
# e.g: 
# has_many_documents :foos
# creates the methods: "foos", and "find_foo(foo_id)"
# A refined version could access the "foos" method metaclass and define a method "find(foo_id)" in order to get: foos.find(foo_id)

module ManyDocuments  
  def self.included(parent)
    parent.send :extend, ManyDocumentsClassMethods
  end

  module ManyDocumentsClassMethods
    
    def has_many_documents(name)
      define_method(name) do
        key_id = self.class.name.downcase + "_id"
        name.to_s.singularize.classify.constantize.all(:conditions => { key_id => self.id.to_s } ).to_a
      end
      
      define_method("find_#{name.to_s.singularize}") do |_key|
        key_id = self.class.name.downcase + "_id"
        name.to_s.singularize.classify.constantize.first(:conditions => { "_id" => _key, key_id => self.id.to_s } )
      end
    end
    
  end
end
