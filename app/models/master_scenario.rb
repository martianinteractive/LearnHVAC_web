class MasterScenario < ActiveRecord::Base
  acts_as_paranoid
  acts_as_taggable
  has_many :scenarios
  has_many :variables, :class_name => "SystemVariable", :foreign_key => "scenario_id"
  has_one :version_note
  belongs_to :user
  belongs_to :client_version, :foreign_key => "desktop_id"
    
  validates_presence_of :name, :user, :client_version
  validates_associated :client_version
  
  def clone!
    clon_atts = attributes.except("id", "created_at", "updated_at")
    clon = MasterScenario.create(clon_atts.merge("name" => "#{name}_clon"))
    variables.each { |var| clon.variables.create var.attributes.except("id", "scenario_id", "created_at", "updated_at") }
    clon
  end
  
  # before_save :delete_version_note
  # after_create :create_initial_version_note  
  # embed_many :system_variables
  # embed_one :version_note
  # 
  # private
  # 
  # def delete_version_note
  #   self.version_note = nil if self.version_note and self.version_note.master_scenario_version != self.version
  # end
  # 
  # def create_initial_version_note
  #   self.create_version_note(:master_scenario_version => self.version, :description => "#{self.name} has been created.")
  # end
  
end
