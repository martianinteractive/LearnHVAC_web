class ScenarioSystemVariablesController < ApplicationController
  before_filter :require_user
  before_filter :find_scenario

  def index
    @scenario_system_variables = @scenario.scenario_system_variables
  end
  
  def new
    @scenario_system_variable = ScenarioSystemVariable.new
  end
  
  def show
    @scenario_system_variable = ScenarioSystemVariable.find(params[:id])
  end

  def edit
    @scenario_system_variable = @scenario.scenario_system_variables.find(params[:id])
  end

  def create
    @scenario_system_variable = ScenarioSystemVariable.new(params[:scenario_system_variable])

    if @scenario_system_variable.save
      redirect_to(@scenario_system_variable, :notice => 'ScenarioSystemVariable was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @scenario_system_variable = @scenario.scenario_system_variables.find(params[:id])

    if @scenario_system_variable.update_attributes(params[:scenario_system_variable])
      redirect_to(@scenario_system_variable, :notice => 'ScenarioSystemVariable was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @scenario_system_variable = ScenarioSystemVariable.find(params[:id])
    @scenario_system_variable.destroy
    redirect_to(scenario_system_variables_url)
  end
  
  
  private
  
  def find_scenario
    @scenario = Scenario.first(:conditions => { :_id => params[:scenario_id], :user_id => current_user.id.to_s })
  end
  
end
