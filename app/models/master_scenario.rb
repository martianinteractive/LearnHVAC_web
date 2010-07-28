class MasterScenario < ActiveRecord::Base
  acts_as_taggable
  has_many :scenarios
  has_many :variables, :class_name => "SystemVariable"
  has_one :version_note
  belongs_to :user
  belongs_to :client_version, :foreign_key => "desktop_id"
  
  # embed_many :system_variables
  # embed_one :version_note
  
  # has_many_related :scenarios
  # belongs_to_related :user
  # belongs_to_related :client_version
  # 
  # index :user_id
  # index :client_version_id
  
  # validates_presence_of :name, :user
  # validates_associated :client_version
  # 
  # before_save :delete_version_note
  # after_create :create_initial_version_note
    
  #skips embeded documents
  # def self.for_display(id_selector=nil, opts={})
  #   f = fields.keys
  #   opts[:add].is_a?(Array) ? opts[:add].each { |field| f << field } : f << opts[:add]
  #   _only = criteria.only(f.compact)
  #   id_selector ? _only.id(id_selector).first : _only
  # end
  
  def clone!(usr=nil)
    clon_atts = self.attributes.except("_id", "user_id").merge(default_clon_attributes)
    clon = MasterScenario.new(clon_atts)
    clon.user = usr || self.user
    sys_vars = []
    self.variables.each { |sv| sys_vars << sv.attributes.except("_id") }
    clon.system_variables = sys_vars
    clon.save
    clon
  end
    
  def default_clon_attributes
    { "version" => 1, "versions" => nil, "system_variables" => nil, "name" => "#{self.name}_clon" }
  end
  
  private
  
  def delete_version_note
    self.version_note = nil if self.version_note and self.version_note.master_scenario_version != self.version
  end
  
  def create_initial_version_note
    self.create_version_note(:master_scenario_version => self.version, :description => "#{self.name} has been created.")
  end
  
end
