Factory.define :group_scenario do |group_scenario|
  group_scenario.association :scenario
  group_scenario.association :group
end