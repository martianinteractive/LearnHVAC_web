Factory.define :scenario do |scenario|
  scenario.name "test scenario"
  scenario.short_description "this is just a scenario"
  scenario.longterm_start_date 1.day.from_now.strftime("%m/%d/%Y")
  scenario.longterm_stop_date 2.days.from_now.strftime("%m/%d/%Y")
  scenario.realtime_start_datetime 25.hours.from_now.strftime("%m/%d/%Y")
end

Factory.define :master_scenario do |master_scenario|
  master_scenario.name "master scenario"
  master_scenario.description "just a master scenario"
  master_scenario.tag_list "first, basic"
  master_scenario.association :client_version, :factory => :client_version
end

Factory.define :user_scenario do |user_scenario|
end
