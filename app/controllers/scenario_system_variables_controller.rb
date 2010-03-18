class ScenarioSystemVariablesController < ApplicationController
  before_filter :require_user
  before_filter :find_scenario
  before_filter :find_scenario_system_variable, :only => [:show, :edit, :update]

  def index
    @scenario_system_variables = @scenario.scenario_system_variables
  end
  
  def new
    @scenario_system_variable = ScenarioSystemVariable.new
  end
  
  def show
  end

  def edit
  end

  def create
    @scenario_system_variable = ScenarioSystemVariable.new(params[:scenario_system_variable])
    @scenario_system_variable.scenario = @scenario
    
    if @scenario_system_variable.save
      redirect_to(scenario_scenario_system_variable_path(@scenario, @scenario_system_variable), :notice => 'ScenarioSystemVariable was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @scenario_system_variable.update_attributes(params[:scenario_system_variable])
      redirect_to(scenario_scenario_system_variable_path(@scenario, @scenario_system_variable), :notice => 'ScenarioSystemVariable was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @scenario.scenario_system_variables.find(params[:id]).destroy
    redirect_to(scenario_scenario_system_variables_path(@scenario))
  end
  
  
  private
  
  def find_scenario
    @scenario = Scenario.first(:conditions => { :_id => params[:scenario_id], :user_id => current_user.id.to_s })
  end
  
  def find_scenario_system_variable
    @scenario_system_variable = @scenario.scenario_system_variables.find(params[:id])
  end
  
end
