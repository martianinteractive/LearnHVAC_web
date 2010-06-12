class Admins::RevisionsController < Admins::ApplicationController 
  before_filter :find_master_scenario
  
  def index
    @versions = @master_scenario.versions.to_a.paginate :page => params[:page], :per_page => 25
  end
  
  def show
    @version = @master_scenario.versions.detect { |v| v.version.to_s == params[:id] }
  end
  
  private
  
  def find_master_scenario
    @master_scenario = MasterScenario.for_display(params[:master_scenario_id], :add => :versions)
  end
  
end
