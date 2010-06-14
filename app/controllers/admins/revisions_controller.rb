class Admins::RevisionsController < Admins::ApplicationController 
  before_filter :find_master_scenario, :add_crumbs, :only => [:index, :show]
  
  def index
    @versions = @master_scenario.versions.to_a.paginate :page => params[:page], :per_page => 25
  end
  
  def show
    @version = @master_scenario.versions.detect { |v| v.version.to_s == params[:id] }
  end
  
  private
  
  def add_crumbs
    add_crumb "Master Scenarios", admins_master_scenarios_path
    add_crumb @master_scenario.name, admins_master_scenario_path(@master_scenario)
    add_crumb "Revisions", admins_master_scenario_revisions_path(@master_scenario)
  end
  
  def find_master_scenario
    @master_scenario = MasterScenario.for_display(params[:master_scenario_id], :add => :versions)
  end
  
end
