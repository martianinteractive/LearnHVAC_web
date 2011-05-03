class Admins::SystemVariablesController < Admins::ApplicationController
  helper :sort
  include SortHelper
  
  before_filter :find_master_scenario, :add_crumbs
  before_filter :find_system_variable, :only => [:show, :edit, :update]
  before_filter :initialize_variables_sort, :only => [:index]
  
  cache_sweeper :system_variable_sweeper, :only => [:create, :update, :update_status, :destroy, :drop]
  
  caches_action :index,
                :cache_path => proc { |c| c.send(:admins_master_scenario_system_variables_path, @master_scenario) },
                :if => proc { |c| c.send(:can_cache_variables?) }
  
  subject_buttons :master_scenario, :only => :index
  subject_buttons :variable, :only => :show
  subject_buttons :cancel_variable, :only => [:new, :edit, :create, :update]
  
  inner_tabs :manage_variables, :only => [:index, :show]
  inner_tabs :new_variable, :only => [:new, :create]
  
  respond_to :js, :only => [:update_status, :drop]
  
  def index
    @variables_grid = initialize_grid(SystemVariable,
                                      :per_page => 25,
                                      :name => "g1",
                                      :conditions => ["scenario_id = ?",@master_scenario.id],
                                      :enable_export_to_csv => true,
                                      :csv_file_name => 'variables'
                                      )
    
    export_grid_if_requested("g1" => "variables_grid")
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
    @system_variables = @master_scenario.variables.find(params[:variables_ids])
    @system_variables.each { |var| var.update_attribute(:disabled, params[:status] == "disable" ) }
  end
  
  def destroy
    var = SystemVariable.find(params[:id])
    var.destroy
    session[:return_to] = admins_master_scenario_system_variables_path(@master_scenario)
    redirect_to([:admins, @master_scenario, :system_variables], :notice => 'System Variable was successfully deleted.')
  end
  
  def drop
    @master_scenario.variables.where(["variables.id in (?)", params[:variables_ids]]).destroy_all
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
    
  def can_cache_variables?
    can_cache_action? and params[:filter].blank?
  end
  
end
