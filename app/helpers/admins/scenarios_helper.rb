module Admins::ScenariosHelper
  def link_to_master_scenario_for(scenario)
    ms = MasterScenario.only(:id, :version).id(scenario.master_scenario_id).first
    ms_name = scenario.master_scenario_name
    ms_version = scenario.master_scenario_version
    if ms.version == ms_version
      link_to "#{ms_name} - Last", admins_master_scenario_path(ms)
    else
      link_to "#{ms_name} - Rev: ##{ms_version}", admins_master_scenario_revision_path(ms, ms_version)
    end
  end
end
