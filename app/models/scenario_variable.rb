class ScenarioVariable
  include Mongoid::Document
  include SystemVariableFields
  
  belongs_to :scenario, :inverse_of => :scenario_variables
  
  validates_presence_of :scenario
end
