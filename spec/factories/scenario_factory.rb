Factory.define :scenario do |scenario|
  scenario.name "test scenario"
  scenario.short_description "this is just a scenario"
end

Factory.define :master_scenario do |master_scenario|
  master_scenario.name "master scenario"
  master_scenario.description "just a master scenario"
  master_scenario.tag_list "first, basic"
end