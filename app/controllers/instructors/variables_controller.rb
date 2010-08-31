class Instructors::VariablesController < Instructors::ApplicationController
  helper :sort
  include SortHelper
    
  before_filter :find_scenario, :add_crumbs
  before_filter :find_scenario_variable, :only => [:show, :edit, :update]
  before_filter :initialize_variables_sort, :only => :index
  
  subject_buttons :scenario, :only => :index
  subject_buttons :variable, :only => :show
  subject_buttons :cancel_variable, :only => [:new, :edit, :create, :update]
  
  inner_tabs :manage_variables, :only => :index
  inner_tabs :new_variable, :only => [:new, :create]
  inner_tabs :variable_name, :only => [:show, :edit, :update]
  
  def index
    params[:filter] = {} if params[:reset].present?
    (update_status and return) if params[:disable].present? or params[:enable].present?
    @scenario_variables = @scenario.variables.filter(params[:filter]).paginate(:page => params[:page], :per_page => 25, :order => sort_clause)
  end
  
  def new
    @scenario_variable = ScenarioVariable.new
    add_crumb "New Variable", new_instructors_scenario_variable_path
  end
  
  def show
    add_crumb @scenario_variable.display_name, instructors_scenario_variable_path(@scenario, @scenario_variable)
  end

  def edit
    add_crumb "Editing #{@scenario_variable.display_name}", edit_instructors_scenario_variable_path(@scenario, @scenario_variable)
  end

  def create
    @scenario_variable = ScenarioVariable.new(params[:scenario_variable])
    @scenario_variable.scenario = @scenario
    
    if @scenario_variable.save
      redirect_to(instructors_scenario_variable_path(@scenario, @scenario_variable), :notice => 'ScenarioVariable was successfully created.')
    else
      add_crumb "New Variable", new_instructors_scenario_variable_path
      render :action => "new"
    end
  end

  def update
    if @scenario_variable.update_attributes(params[:scenario_variable])
      redirect_to(instructors_scenario_variable_path(@scenario, @scenario_variable), :notice => 'ScenarioVariable was successfully updated.')
    else
      render :action => "edit"
      add_crumb "Editing #{@scenario_variable.display_name}", edit_instructors_scenario_variable_path(@scenario, @scenario_variable)
    end
  end
  
  def update_status
    redirect_to(:back, :notice => "Please select at least one variable") unless params[:variables_ids].present?
    
    if @scenario.variables.update_all("disabled = #{params[:disable].present?}", ["variables.id in (?)", params[:variables_ids]])
      redirect_to([:instructors, @scenario, :variables], :notice => 'Variables were successfully updated.')
    else
      redirect_to(:back, :notice => "There were problems updating the variables status.")
    end
  end

  def destroy
    @scenario.variables.find(params[:id]).destroy
    redirect_to(instructors_scenario_variables_path(@scenario))
  end
  
  private
  
  def add_crumbs
    add_crumb "Scenarios", instructors_scenarios_path
    add_crumb @scenario.name, instructors_scenario_path(@scenario)
    add_crumb "Manage Variables", instructors_scenario_variables_path(@scenario)
  end
  
  def find_scenario
    @scenario = current_user.created_scenarios.find(params[:scenario_id])
  end
  
  def find_scenario_variable
    @scenario_variable = @scenario.variables.find(params[:id])
  end
    
end
