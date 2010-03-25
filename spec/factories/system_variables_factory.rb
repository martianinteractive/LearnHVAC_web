Factory.define :system_variable do |system_variable|
  system_variable.name "System Variable 01"
  system_variable.display_name "Sys Var"
  system_variable.min_value 0
  system_variable.default_value 1
  system_variable.max_value 10
  system_variable.type_code 0
end

Factory.define :scenario_variable do |scenario_variable|
  scenario_variable.name "Scenario Variable 01"
  scenario_variable.display_name "Scene Var"
  scenario_variable.min_value 0
  scenario_variable.default_value 1
  scenario_variable.max_value 10
  scenario_variable.type_code 0
end