class Managers::ScenarioVariablesController < Managers::ApplicationController
  helper :sort
  include SortHelper
  before_filter :find_scenario, :add_crumbs
  before_filter :initialize_variables_sort, :only => [:index]
  
  def index
    @scenario_variables = @scenario.variables.paginate :page => params[:page], :per_page => 25
  end
  
  def show
    @scenario_variable = @scenario.variables.find(params[:id])
  end
  
  private
  
  def find_scenario
    @scenario = current_user.institution.scenarios.find(params[:scenario_id])
  end
  
  def add_crumbs
    add_crumb "Scenarios", managers_scenarios_path
    add_crumb @scenario.name, managers_scenario_path(@scenario)
    add_crumb "Simulation Variables", managers_scenario_variables_path(@scenario)
  end
  
end
