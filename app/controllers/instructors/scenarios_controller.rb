class Instructors::ScenariosController < Instructors::ApplicationController
  before_filter :find_scenario, :only => [:show, :edit, :access, :update, :destroy]
  add_crumb("Scenarios") { |instance| instance.send :instructors_scenarios_path }
  
  def index
    @scenarios = current_user.scenarios.paginate :page => params[:page], :per_page => 25
  end

  def show
    add_crumb @scenario.name, instructors_scenario_path(@scenario)
  end
  
  def access
    add_crumb @scenario.name, instructors_scenario_path(@scenario)
    add_crumb "Observers", access_instructors_scenario_path(@scenario)
  end

  def new
    @scenario = Scenario.new
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
    @scenario = current_user.scenarios.find(params[:id])
  end
  
end
