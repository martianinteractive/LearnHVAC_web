class Instructors::ScenariosController < Instructors::ApplicationController
  before_filter :find_scenario, :only => [:show, :edit, :access, :update, :destroy]
  
  cache_sweeper :scenario_sweeper, :only => [:create, :update, :destroy]
  
  subject_buttons :scenario, :only => :show
  subject_buttons :cancel_scenario, :only => [:new, :edit, :create, :update]
  
  inner_tabs :scenario_details
  
  add_crumb("Scenarios") { |instance| instance.send :instructors_scenarios_path }
  
  def index
    @scenarios = current_user.created_scenarios.paginate :page => params[:page], :per_page => 25
  end

  def show
    add_crumb @scenario.name, instructors_scenario_path(@scenario)
  end

  def new
    @scenario = Scenario.new(:longterm_start_date => Time.now,
                             :longterm_stop_date => Time.now+7.days,
                             :realtime_start_datetime => Time.now
                             )
    add_crumb "New Scenario", new_instructors_scenario_path
  end

  def edit
    add_crumb "Editing #{@scenario.name}", edit_instructors_scenario_path(@scenario)
  end
  
  def create
    @scenario = Scenario.new(params[:scenario])
    @scenario.user = current_user
    
    if @scenario.save
      redirect_to instructors_scenario_path(@scenario), :notice => 'Scenario was successfully created.'
    else
      render :action => "new"
      add_crumb "New Scenario", new_instructors_scenario_path
    end
  end

  def update    
    if @scenario.update_attributes(params[:scenario])
      redirect_to instructors_scenario_path(@scenario), :notice => 'Scenario was successfully updated.'
    else
      render :action => "edit"
      add_crumb "Editing #{@scenario.name}", edit_instructors_scenario_path(@scenario)
    end
  end

  def destroy
    @scenario.destroy
    redirect_to(instructors_scenarios_url)
  end
  
  private
  
  def find_scenario
    @scenario = current_user.created_scenarios.find(params[:id])
  end
  
end
