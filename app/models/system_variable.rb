class SystemVariable
  include Mongoid::Document
  include SystemVariableFields
  
  embedded_in :master_scenario, :inverse_of => :system_variables
  
  validates_presence_of :master_scenario
  
end
