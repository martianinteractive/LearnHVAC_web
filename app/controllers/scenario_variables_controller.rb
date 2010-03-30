class ScenarioVariablesController < ApplicationController
  before_filter :require_user
  before_filter :find_scenario
  before_filter :find_scenario_variable, :only => [:show, :edit, :update]
  helper :sort
  include SortHelper
  before_filter :initialize_variables_sort, :only => [:index]
  
  
  def index
    @scenario_variables = doc_sort(@scenario.scenario_variables).paginate :page => params[:page], :per_page => 25
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
      redirect_to(scenario_scenario_variable_path(@scenario, @scenario_variable), :notice => 'ScenarioVariable was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @scenario_variable.update_attributes(params[:scenario_variable])
      redirect_to(scenario_scenario_variable_path(@scenario, @scenario_variable), :notice => 'ScenarioVariable was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @scenario.scenario_variables.find(params[:id]).destroy
    redirect_to(scenario_scenario_variables_path(@scenario))
  end
  
  
  private
  
  def find_scenario
    @scenario = current_user.find_scenario(params[:scenario_id])
  end
  
  def find_scenario_variable
    @scenario_variable = @scenario.scenario_variables.find(params[:id])
  end
  
end
