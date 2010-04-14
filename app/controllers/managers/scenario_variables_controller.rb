class Managers::ScenarioVariablesController < Managers::ApplicationController
  before_filter :find_scenario
  helper :sort
  include SortHelper
  before_filter :initialize_variables_sort, :only => [:index]
  
  def index
    @scenario_variables = doc_sort(@scenario.scenario_variables).paginate :page => params[:page], :per_page => 25
  end
  
  def show
    @scenario_variable = @scenario.scenario_variables.find(params[:id])
  end
  
  private
  
  def find_scenario
    @scenario = current_user.institution.scenarios.find { |s| s.id == params[:scenario_id] }
  end
  
end
