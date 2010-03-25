class Scenario
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Document::ProtectedAttributes
  include ScenarioFields
  
  has_many :scenario_variables
  belongs_to_related :user
  belongs_to_related :master_scenario
  
  named_scope :recently_created, criteria.where(:created_at.gt => (Time.now + 30.days))
  named_scope :recently_updated, criteria.where(:updated_at.gt => (Time.now + 30.days))
    
  attr_protected :user_id
  
  after_create :copy_system_variables
  
  private
  
  def copy_system_variables
    # Using try to not break existing controllers specs, but master_scenario will be required.
    self.master_scenario.try(:system_variables).try(:each) do |sv|
      scen_var_atts = sv.attributes
      scen_var_atts.delete("_id")
      scen_var_atts.delete("_type")
      self.scenario_variables.create(scen_var_atts)
    end
  end
  
end
