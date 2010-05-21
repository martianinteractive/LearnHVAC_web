class Directory::VariablesController < Directory::ApplicationController
  helper :sort
  include SortHelper
  before_filter :find_institution_and_scenario
  before_filter :initialize_variables_sort, :only => [:index]
  
  def index
    @variables = doc_sort(@scenario.scenario_variables).paginate :page => params[:page], :per_page => 25
  end
  
  def show
    @variable = @scenario.scenario_variables.find(params[:id])
  end
  
  private
  
  def find_institution_and_scenario
    @institution = Institution.find(params[:institution_id])
    @scenario = @institution.scenarios.public.criteria.id(params[:scenario_id]).first
  end
  
end
