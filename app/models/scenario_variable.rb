class ScenarioVariable
  include Mongoid::Document
  include SystemVariableFields
  
  belongs_to :scenario, :inverse_of => :scenario_variables
end
