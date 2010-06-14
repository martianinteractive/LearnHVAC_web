class Admins::MasterScenariosController < Admins::ApplicationController 
   add_crumb("Master Scenarios") { |instance| instance.send :admins_master_scenarios_path }
   
  def index
    @master_scenarios = MasterScenario.for_display.paginate :page => params[:page], :per_page => 25
  end
  
  def tag
    @master_scenarios = MasterScenario.tagged_with(params[:tag]).paginate :page => params[:page], :per_page => 25
  end
  
  def show
    @master_scenario = MasterScenario.for_display(params[:id])
    add_crumb @master_scenario.name, admins_master_scenario_path(@master_scenario)
  end

  def new
    @master_scenario = MasterScenario.new
    add_crumb "New Scenario", new_admins_master_scenario_path
  end

  def edit
    @master_scenario = MasterScenario.find(params[:id])
    add_crumb "Editing #{@master_scenario.name}", edit_admins_master_scenario_path(@master_scenario)
  end
  
  def clone
    @master_scenario = MasterScenario.find(params[:id])
    clon = @master_scenario.clone!
    notice = clon.valid? ? "Master Scenario was successfully cloned" : "There were problems cloning the Master Scenario"
    redirect_to(admins_master_scenarios_path, :notice => notice)
  end
  
  def create
    @master_scenario = MasterScenario.new(params[:master_scenario])
    @master_scenario.user = current_user
    
    if @master_scenario.save
      redirect_to(admins_master_scenario_path(@master_scenario), :notice => 'Scenario was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @master_scenario = MasterScenario.find(params[:id])
    
    if @master_scenario.update_attributes(params[:master_scenario])
      redirect_to(admins_master_scenario_path(@master_scenario), :notice => 'Scenario was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @master_scenario = MasterScenario.find(params[:id])
    
    @master_scenario.destroy
    redirect_to(admins_master_scenarios_url)
  end
  
end
