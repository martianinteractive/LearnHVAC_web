class Admins::VariablesController < Admins::ApplicationController
  helper :sort
  include SortHelper
  
  subject_buttons :scenario, :only => :index
  subject_buttons :variable, :only => :show
  subject_buttons :cancel_variable, :only => [:new, :edit, :create, :update]
  inner_tabs :manage_variables, :except => [:new]
  inner_tabs :new_variable, :only => [:new]
  
  before_filter :find_scenario, :add_crumbs
  before_filter :find_scenario_variable, :only => [:show, :edit, :update]
  before_filter :initialize_variables_sort, :only => [:index]
  
  def index
    @scenario_variables = @scenario.variables.order(sort_clause).paginate :page => params[:page], :per_page => 25
  end
  
  def new
    @scenario_variable = ScenarioVariable.new
  end
  
  def show
  end

  def edit
    add_crumb "Edit", edit_admins_scenario_variable_path(@scenario, @scenario_variable)
  end

  def create
    @scenario_variable = ScenarioVariable.new(params[:scenario_variable])
    @scenario_variable.scenario = @scenario

    if @scenario_variable.save
      redirect_to(admins_scenario_variable_path(@scenario, @scenario_variable), :notice => 'Variable was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @scenario_variable.update_attributes(params[:scenario_variable])
      redirect_to(admins_scenario_variable_path(@scenario, @scenario_variable), :notice => 'Variable was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @scenario.variables.find(params[:id]).destroy
    redirect_to(admins_scenario_variables_path(@scenario), :notice => 'Variable was successfully deleted.')
  end
  
  
  private
  
  def add_crumbs
    add_crumb "Instructor Scenarios", admins_scenarios_path
    add_crumb @scenario.name, admins_scenario_path(@scenario)
    add_crumb "Variables", admins_scenario_variables_path(@scenario)
  end
  
  def find_scenario
    @scenario = Scenario.find(params[:scenario_id])
  end
  
  def find_scenario_variable
    @scenario_variable = @scenario.variables.find(params[:id])
    add_crumb @scenario_variable.name, admins_scenario_variable_path(@scenario, @scenario_variable)
  end
  
end
