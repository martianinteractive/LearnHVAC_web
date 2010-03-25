class Admin::SystemVariablesController < Admin::ApplicationController
  before_filter :find_master_scenario
  before_filter :find_system_variable, :only => [:show, :edit, :update]
  
  def index
    @system_variables = @master_scenario.system_variables.paginate :page => params[:page], :per_page => 25
  end

  def show
  end

  def new
    @system_variable = SystemVariable.new
  end

  def edit
  end

  def create
    @system_variable = SystemVariable.new(params[:system_variable])
    @system_variable.master_scenario = @master_scenario
    
    if @system_variable.save
      redirect_to(admin_master_scenario_system_variable_path(@master_scenario, @system_variable), :notice => 'System Variable was successfully created.')
    else
      render :action => :new
    end
  end

  def update
    if @system_variable.update_attributes(params[:system_variable])
      redirect_to(admin_master_scenario_system_variable_path(@master_scenario, @system_variable), :notice => 'System Variable was successfully created.')
    else
      render :action => :edit
    end
  end

  def destroy
    @master_scenario.system_variables.find(params[:id]).destroy
    redirect_to(admin_master_scenario_system_variables_path(@master_scenario))
  end
  
  private
  
  def find_master_scenario
    @master_scenario = MasterScenario.find(params[:master_scenario_id])
  end
  
  def find_system_variable
    @system_variable = @master_scenario.system_variables.find(params[:id])
  end
end
