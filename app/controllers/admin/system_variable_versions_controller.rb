class Admin::SystemVariableVersionsController < Admin::ApplicationController 
  include SortHelper
  helper :sort
  before_filter :find_master_scenario_and_version
  before_filter :initialize_variables_sort, :only => [:index]
  
  def index
    @system_variable_versions = doc_sort(@version.system_variables).paginate(:page => params[:page], :per_page => 25)
  end
  
  def show
    @system_variable_version = @version.system_variables.find(params[:id])
  end
  
  private
  
  def find_master_scenario_and_version
    @master_scenario = MasterScenario.find(params[:master_scenario_id])
    @version = @master_scenario.versions.detect { |v| v.version.to_s == params[:revision_id] }
  end
  
end
