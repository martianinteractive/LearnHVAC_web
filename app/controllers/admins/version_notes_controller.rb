class Admins::VersionNotesController < Admins::ApplicationController
  before_filter :find_master_scenario
  
  def new
    add_crumb @master_scenario.name, admins_master_scenario_path(@master_scenario)
    @version_note = VersionNote.new
  end
  
  def create
    @version_note = VersionNote.new(params[:version_note])
    @version_note.master_scenario = @master_scenario
    
    if @version_note.save
      redirect_to(admins_master_scenario_path(@master_scenario), :notice => "Notes were successfully created.")
    else
      render :action => "new"
    end
  end
  
  private 
  
  def find_master_scenario
    @master_scenario = MasterScenario.for_display(params[:master_scenario_id])
  end
  
end
