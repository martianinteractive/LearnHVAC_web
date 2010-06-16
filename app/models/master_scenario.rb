class MasterScenario
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Document::Taggable
  field :name
  field :description
  
  embed_many :system_variables
  embed_one :version_note
  
  has_many_related :scenarios
  belongs_to_related :user
  belongs_to_related :client_version
  
  index :user_id
  index :client_version_id
  
  validates_presence_of :name, :user, :client_version
    
  #skips embeded documents
  def self.for_display(id_selector=nil, opts={})
    f = fields.keys
    f << opts[:add] if opts[:add]
    _only = criteria.only(f)
    id_selector ? _only.id(id_selector).first : _only
  end
  
  def clone!(usr=nil)
    clon_atts = self.attributes.except("_id", "user_id").merge(default_clon_attributes)
    clon = MasterScenario.new(clon_atts)
    clon.user = usr || self.user
    sys_vars = []
    self.system_variables.each { |sv| sys_vars << sv.attributes.except("_id") }
    clon.system_variables = sys_vars
    clon.save
    clon
  end
    
  def default_clon_attributes
    { "version" => 1, "versions" => nil, "system_variables" => nil, "name" => "#{self.name}_clon" }
  end
    
end
