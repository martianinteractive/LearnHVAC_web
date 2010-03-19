class Admin::ScenarioVariablesController < ApplicationController
  before_filter :require_admin
  before_filter :find_scenario
  before_filter :find_scenario_variable, :only => [:show, :edit, :update]
  layout "admin"
  
  def index
    @scenario_variables = @scenario.scenario_variables
  end
  
  def new
    @scenario_variable = ScenarioVariable.new
  end
  
  def show
  end

  def edit
  end

  def create
    @scenario_variable = ScenarioVariable.new(params[:scenario_variable])
    @scenario_variable.scenario = @scenario
    
    if @scenario_variable.save
      redirect_to(admin_scenario_scenario_variable_path(@scenario, @scenario_variable), :notice => 'ScenarioVariable was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @scenario_variable.update_attributes(params[:scenario_variable])
      redirect_to(admin_scenario_scenario_variable_path(@scenario, @scenario_variable), :notice => 'ScenarioVariable was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @scenario.scenario_variables.find(params[:id]).destroy
    redirect_to(admin_scenario_scenario_variables_path(@scenario))
  end
  
  
  private
  
  def find_scenario
    @scenario = Scenario.find(params[:scenario_id])
  end
  
  def find_scenario_variable
    @scenario_variable = @scenario.scenario_variables.find(params[:id])
  end
  
end
