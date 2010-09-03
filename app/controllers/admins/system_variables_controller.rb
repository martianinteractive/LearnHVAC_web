class Admins::SystemVariablesController < Admins::ApplicationController
  helper :sort
  include SortHelper
  
  before_filter :find_master_scenario, :add_crumbs
  before_filter :find_system_variable, :only => [:show, :edit, :update]
  before_filter :initialize_variables_sort, :only => [:index]
  
  subject_buttons :master_scenario, :only => :index
  subject_buttons :variable, :only => :show
  subject_buttons :cancel_variable, :only => [:new, :edit, :create, :update]
  
  inner_tabs :manage_variables, :only => [:index, :show]
  inner_tabs :new_variable, :only => [:new, :create]
  
  respond_to :js, :only => [:update_status, :drop]
  
  def index
    params[:filter] = {} if params[:reset].present?
    @system_variables = @master_scenario.variables.filter(params[:filter]).paginate(:page => params[:page], :per_page => 25, :order => sort_clause)
  end
  
  def show
  end

  def new
    @system_variable = SystemVariable.new
  end

  def edit
    add_crumb "Editing #{@system_variable.name}", edit_admins_master_scenario_system_variable_path(@master_scenario, @system_variable)
  end

  def create
    @system_variable = SystemVariable.new(params[:system_variable])
    @system_variable.master_scenario = @master_scenario
    
    if @system_variable.save
      session[:return_to] = admins_master_scenario_system_variable_path(@master_scenario, @system_variable)
      redirect_to([:admins, @master_scenario, @system_variable], :notice => 'System Variable was successfully created.')
    else
      render :action => :new
    end
  end

  def update
    if @system_variable.update_attributes(params[:system_variable])
      redirect_to([:admins, @master_scenario, @system_variable], :notice => 'System Variable was successfully created.')
    else
      render :action => :edit
    end
  end
  
  def update_status        
    disable = params[:status] == "disable"
    
    if @master_scenario.variables.update_all("disabled = #{disable}", ["variables.id in (?)", params[:variables_ids]])
      @system_variables = @master_scenario.variables.find(params[:variables_ids])
      
      respond_to do |wants|
        wants.js
      end
    end
  end
  
  def destroy
    @master_scenario.variables.find(params[:id]).destroy
    session[:return_to] = admins_master_scenario_system_variables_path(@master_scenario)
    redirect_to([:admins, @master_scenario, :system_variables], :notice => 'System Variable was successfully deleted.')
  end
  
  def drop
    # calling delete_all (since we don't have callbacks or depedant associations on variables) to speed-up this request.
    @master_scenario.variables.where(["variables.id in (?)", params[:variables_ids]]).delete_all
  end
  
  def yaml_dump
    @vars = {}
    @master_scenario.variables.each do |var|
      @vars[var.name.to_s] = var.attributes.except("_id").to_hash
    end
    @vars
  end
  
  private
  
  def add_crumbs
    add_crumb "Master Scenarios", admins_master_scenarios_path
    add_crumb @master_scenario.name, admins_master_scenario_path(@master_scenario)
    add_crumb "System Variables", admins_master_scenario_system_variables_path(@master_scenario)
  end
  
  def find_master_scenario
    @master_scenario = MasterScenario.find(params[:master_scenario_id])
  end
  
  def check_version_notes
    redirect_to(new_admins_master_scenario_version_note_path(@master_scenario)) unless @master_scenario.version_note
  end
  
  def find_system_variable
    @system_variable = @master_scenario.variables.find(params[:id])
  end
    
end
