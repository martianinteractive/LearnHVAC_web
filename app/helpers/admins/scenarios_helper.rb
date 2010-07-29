module Admins::ScenariosHelper
  def link_to_master_scenario_for(scenario)
    scenario.master_scenario ? link_to(scenario.master_scenario.name, [:admins, scenario.master_scenario]) : "deleted"
  end
end
