class MasterScenario
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Document::Taggable
  field :name
  field :description
  
  embed_many :system_variables
  
  has_many_related :scenarios
  belongs_to_related :user
  belongs_to_related :client_version
  
  validates_presence_of :name, :user
  
  def clone!
    clon_atts = self.attributes
    clon_atts.delete("_id")
    clon_atts.delete("version")
    clon_atts.delete("versions")
    clon_atts.delete("system_variables")
    clon_atts["name"] = "#{self.name}_clon"
    clon = MasterScenario.create(clon_atts)
    self.system_variables.each do |sv| 
      sys_var_clon_atts = sv.attributes
      sys_var_clon_atts.delete("_id")
      clon.system_variables.create(sys_var_clon_atts)
    end
    clon
  end
  
end
