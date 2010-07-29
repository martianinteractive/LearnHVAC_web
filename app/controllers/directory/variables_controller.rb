class Directory::VariablesController < Directory::ApplicationController
  helper :sort
  include SortHelper
  before_filter :find_institution_and_scenario
  before_filter :initialize_variables_sort, :only => [:index]
  
  def index
    @variables = @scenario.variables.order(sort_clause).paginate :page => params[:page], :per_page => 25
  end
  
  def show
    @variable = @scenario.variables.find(params[:id])
  end
  
  private
  
  def find_institution_and_scenario
    @institution = Institution.find(params[:institution_id])
    @scenario = @institution.scenarios.public.find(params[:scenario_id])
  end
  
end
