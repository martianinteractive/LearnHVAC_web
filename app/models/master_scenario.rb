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
  
  index :user_id
  index :client_version_id
  
  validates_presence_of :name, :user, :client_version
  
  after_update :notify_change
  
  def clone!
    clon_atts = self.attributes.merge(default_clon_attributes)
    clon_atts.delete("_id")
    clon = MasterScenario.new(clon_atts)
    sys_vars = []
    self.system_variables.each do |sv| 
      sys_vars << sv.attributes
      sys_vars.last.delete("_id")   
    end
    clon.system_variables = sys_vars
    clon.save
    clon
  end
    
  def default_clon_attributes
    { "version" => 1, "versions" => nil, "system_variables" => nil, "name" => "#{self.name}_clon" }
  end
  
  def notify_change
    "I've changed."
  end
  
end
