class Admins::VariablesController < Admins::ApplicationController

  helper :sort
  include SortHelper

  before_filter :find_scenario
  before_filter :find_scenario_variable, :only => [:show, :edit, :update]
  before_filter :initialize_variables_sort, :load_variables_filters, :only => [:index]

  cache_sweeper :scenario_variable_sweeper, :only => [:create, :update, :update_status, :destroy, :drop]

  caches_action :index,
                :cache_path => proc { |c| c.send(:admins_scenario_variables_path, @scenario) },
                :if => proc { |c| c.send(:can_cache_variables?) }

  subject_buttons :scenario, :only => :index
  subject_buttons :variable, :only => :show
  subject_buttons :cancel_variable, :only => [:new, :edit, :create, :update]

  inner_tabs :manage_variables, :only => [:index, :show, :edit]
  inner_tabs :new_variable, :only => [:new, :create]

  respond_to :js, :only => [:update_status, :drop]

  def index
    @scenario_variables = @scenario.variables.filter @filters
    respond_to do |wants|
      wants.html
      wants.csv { render :csv => @scenario_variables }
    end
  end

  def new
    @scenario_variable = ScenarioVariable.new
  end

  def show
  end

  def edit
  end

  def create
    @scenario_variable = @scenario.varible.build(params[:scenario_variable])

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

  def update_status
    @variables = @scenario.variables.find(params[:variables_ids])
    #lets trigger callbacks.
    @variables.each { |var| var.update_attribute(:disabled, params[:status] == "disable" ) }
  end

  def destroy
    @scenario.variables.find(params[:id]).destroy
    redirect_to(admins_scenario_variables_path(@scenario), :notice => 'Variable was successfully deleted.')
  end

  def drop
    @scenario.variables.where(["variables.id in (?)", params[:variables_ids]]).destroy_all
  end

  private

  def find_scenario
    @scenario = Scenario.find(params[:scenario_id])
  end

  def find_scenario_variable
    @scenario_variable = @scenario.variables.find(params[:id])
  end

  def can_cache_variables?
    can_cache_action? and params[:filter].blank?
  end

end
