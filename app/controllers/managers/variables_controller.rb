class Managers::VariablesController < Managers::ApplicationController

  layout 'bootstrap'

  helper :sort
  include SortHelper
  before_filter :find_scenario
  before_filter :initialize_variables_sort, :only => [:index]

  def index
    @scenario_variables = @scenario.variables.order(sort_clause).paginate :page => params[:page], :per_page => 25
  end

  def show
    @scenario_variable = @scenario.variables.find(params[:id])
  end

  private

  def find_scenario
    @scenario = current_user.institution.scenarios.find(params[:scenario_id])
  end

end
