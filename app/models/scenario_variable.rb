class ScenarioVariable
  include Mongoid::Document
  include SystemVariableFields
  
  embedded_in :scenario, :inverse_of => :scenario_variables
  
  validates_presence_of :scenario
end
