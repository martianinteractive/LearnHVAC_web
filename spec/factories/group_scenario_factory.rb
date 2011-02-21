Factory.define :group_scenario do |group_scenario|
  group_scenario.scenario { Factory(:valid_scenario) }
  group_scenario.group { Factory(:valid_group) }
end