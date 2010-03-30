class Admin::MasterScenariosController < Admin::ApplicationController 
   
  def index
    @master_scenarios = MasterScenario.all.to_a.paginate :page => params[:page], :per_page => 25
  end
  
  def tags
    if params[:term]
      term = params[:term].split(",").last.strip
      @tags = MasterScenario.tagged_like(term)
    end
    
    if @tags.any?
      render :js => @tags.to_json
    else
      render :nothing => true
    end
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
  
  def clone
    @master_scenario = MasterScenario.find(params[:id])
    clon = @master_scenario.clone!
    notice = clon.valid? ? "Master Scenario was successfully cloned" : "There were problems cloning the Master Scenario"
    redirect_to(admin_master_scenarios_path, :notice => notice)
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
