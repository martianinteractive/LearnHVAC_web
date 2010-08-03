class Instructors::AccessController < Instructors::ApplicationController
  before_filter :find_scenario, :add_crumbs
  inner_tabs :manage_access
  subject_buttons :scenario, :only => :show
  
  def show
  end
  
  private
  
  def find_scenario
    @scenario = current_user.scenarios.find(params[:scenario_id])
  end
  
  def add_crumbs
    add_crumb "Scenarios", instructors_scenarios_path
    add_crumb @scenario.name, instructors_scenario_path(@scenario)
    add_crumb "Manage Access", instructors_scenario_access_path(@scenario)
  end
  
end
