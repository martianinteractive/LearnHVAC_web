class SystemVariable
  include Mongoid::Document
  include SystemVariableFields
  
  belongs_to :master_scenario, :inverse_of => :system_variables
end
