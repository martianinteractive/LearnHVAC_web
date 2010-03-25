class Admin::MasterScenariosController < Admin::ApplicationController
  
  def index
    @master_scenarios = MasterScenario.all.to_a.paginate :page => params[:page], :per_page => 25
  end

  def show
    @master_scenario = MasterScenario.find(params[:id])
  end

  def new
    @master_scenario = MasterScenario.new
  end

  def edit
    @master_scenario = MasterScenario.find(params[:id])
  end
  
  def create
    @master_scenario = MasterScenario.new(params[:master_scenario])
    @master_scenario.user = current_user
    
    if @master_scenario.save
      redirect_to(admin_master_scenario_path(@master_scenario), :notice => 'Scenario was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @master_scenario = MasterScenario.find(params[:id])
    
    if @master_scenario.update_attributes(params[:master_scenario])
      redirect_to(admin_master_scenario_path(@master_scenario), :notice => 'Scenario was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @master_scenario = MasterScenario.find(params[:id])
    
    @master_scenario.destroy
    redirect_to(admin_master_scenarios_url)
  end
  
end
