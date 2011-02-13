class Admins::MasterScenariosController < Admins::ApplicationController 
  before_filter :find_master_scenario, :only => [ :show, :edit, :clone, :update, :destroy ]
  
  cache_sweeper :master_scenario_sweeper, :only => [ :create, :update, :clone, :destroy ]
  
  caches_action :index, 
                :cache_path => proc { |c| c.send(:admins_master_scenarios_path) }, 
                :if => proc { |c| c.send(:can_cache_action?) }
                
  caches_action :show,
                :cache_path => proc { |c| c.send(:admins_master_scenario_path, @scenario) },
                :if => proc { |c| c.send(:can_cache_action?) }
  
  subject_buttons :master_scenario, :only => [:show]
  subject_buttons :cancel_master_scenario, :only => [ :new, :edit, :create, :update ]
  inner_tabs :master_scenario_details, :only => [ :show, :edit ]
  
  add_crumb("Master Scenarios") { |instance| instance.send :admins_master_scenarios_path }
  
  def index
    @master_scenarios = MasterScenario.paginate :page => params[:page], :per_page => 25
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
    clon = @master_scenario.clone!
    notice = clon.valid? ? "Master Scenario was successfully cloned" : "There were problems cloning the Master Scenario"
    redirect_to(admins_master_scenarios_path, :notice => notice)
  end
  
  def create
    @master_scenario = MasterScenario.new(params[:master_scenario])
    @master_scenario.user = current_user
    
    if @master_scenario.save
      redirect_to([:admins, @master_scenario], :notice => "Scenario was succesfully created.")
    else
      add_crumb "New Scenario", new_admins_master_scenario_path
      render :action => "new"
    end
  end

  def update
    if @master_scenario.update_attributes(params[:master_scenario])
      redirect_to([:admins, @master_scenario], :notice => "Scenario was succesfully updated.")
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
    @master_scenario = MasterScenario.find(params[:id])
  end
  
  def check_version_notes
    redirect_to(new_admins_master_scenario_version_note_path(@master_scenario)) unless @master_scenario.version_note
  end
  
end
