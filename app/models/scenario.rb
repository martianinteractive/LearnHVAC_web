class Scenario
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Document::ProtectedAttributes
  include ScenarioFields
    
  has_many :scenario_variables
  belongs_to_related :user
  belongs_to_related :master_scenario
  
  validates_presence_of :master_scenario, :user, :name

  
  named_scope :recently_created, criteria.where(:created_at.gt => (Time.now + 30.days))
  named_scope :recently_updated, criteria.where(:updated_at.gt => (Time.now + 30.days))
    
  attr_protected :user_id
  
  before_create :assign_master_scenario
  after_create :copy_system_variables
  
  private
  
  def assign_master_scenario
      self.master_scenario_name = self.master_scenario.name
      self.master_scenario_version = self.master_scenario.updated_at.to_time.to_i
  end
  
  def copy_system_variables
    self.master_scenario.system_variables.each do |system_variables|
      sys_var_attributes = system_variables.attributes
      sys_var_attributes.delete("_id")
      sys_var_attributes.delete("_type")
      self.scenario_variables.create(sys_var_attributes)
    end
  end
  
end
