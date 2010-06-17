class Admins::MasterScenariosController < Admins::ApplicationController 
  before_filter :find_master_scenario, :only => [:show, :edit, :clone, :update, :destroy]
  before_filter :check_version_notes, :only => [:show, :edit, :update]
  add_crumb("Master Scenarios") { |instance| instance.send :admins_master_scenarios_path }
   
  def index
    @master_scenarios = MasterScenario.for_display.paginate :page => params[:page], :per_page => 25
  end
  
  def tag
    @master_scenarios = MasterScenario.tagged_with(params[:tag]).paginate :page => params[:page], :per_page => 25
  end
  
  def show
    add_crumb @master_scenario.name, admins_master_scenario_path(@master_scenario)
  end

  def new
    @master_scenario = MasterScenario.new
    add_crumb "New Scenario", new_admins_master_scenario_path
  end

  def edit
    add_crumb "Editing #{@master_scenario.name}", edit_admins_master_scenario_path(@master_scenario)
  end
  
  def clone
    clon = @master_scenario.clone!(current_user)
    notice = clon.valid? ? "Master Scenario was successfully cloned" : "There were problems cloning the Master Scenario"
    redirect_to(admins_master_scenarios_path, :notice => notice)
  end
  
  def create
    @master_scenario = MasterScenario.new(params[:master_scenario])
    @master_scenario.user = current_user
    
    if @master_scenario.save
      redirect_to(new_admins_master_scenario_version_note_path(@master_scenario), :notice => 'Scenario was successfully created.')
    else
      add_crumb "New Scenario", new_admins_master_scenario_path
      render :action => "new"
    end
  end

  def update
    if @master_scenario.update_attributes(params[:master_scenario])
      redirect_to(new_admins_master_scenario_version_note_path(@master_scenario), :notice => 'Scenario was successfully updated.')
    else
      add_crumb "Editing #{@master_scenario.name}", edit_admins_master_scenario_path(@master_scenario)
      render :action => "edit"
    end
  end

  def destroy
    @master_scenario.destroy
    redirect_to(admins_master_scenarios_url)
  end
  
  private
  
  def find_master_scenario
    if ["show", "edit"].include? params[:action]
      @master_scenario = MasterScenario.for_display(params[:id], :add => [:version_note, :system_variables])
    else
      @master_scenario = MasterScenario.find(params[:id])
    end
  end
  
  def check_version_notes
    redirect_to(new_admins_master_scenario_version_note_path(@master_scenario)) unless @master_scenario.version_note
  end
  
end
