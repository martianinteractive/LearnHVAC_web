class Admins::SystemVariableVersionsController < Admins::ApplicationController 
  helper :sort
  include SortHelper
  before_filter :find_master_scenario_and_version, :add_crumbs
  before_filter :initialize_variables_sort, :only => [:index]
  
  def index
    @system_variable_versions = doc_sort(@version.system_variables).paginate(:page => params[:page], :per_page => 25)
  end
  
  def show
    @system_variable_version = @version.system_variables.find(params[:id])
    add_crumb @system_variable_version.name, admins_master_scenario_revision_variable_path(@master_scenario, @version.version, @system_variable_version)
  end
  
  private
  
  def find_master_scenario_and_version
    @master_scenario = MasterScenario.for_display(params[:master_scenario_id], :add => :versions)
    @version = @master_scenario.versions.detect { |v| v.version.to_s == params[:revision_id] }
  end
  
  def add_crumbs
    add_crumb "Master Scenarios", admins_master_scenarios_path
    add_crumb @master_scenario.name, admins_master_scenario_path(@master_scenario)
    add_crumb "Revisions", admins_master_scenario_revisions_path(@master_scenario)
    add_crumb "Variables", admins_master_scenario_revision_variables_path(@master_scenario, @version.version)
  end
  
end
