class Instructor::ScenariosController < Instructor::ApplicationController
  before_filter :find_scenario, :only => [:show, :edit, :update, :destroy]
  
  def index
    @scenarios = current_user.scenarios.paginate :page => params[:page], :per_page => 25
  end

  def show
  end

  def new
    @scenario = Scenario.new
  end

  def edit
  end
  
  def create
    @scenario = Scenario.new(params[:scenario])
    @scenario.user = current_user
    
    if @scenario.save
      redirect_to instructor_scenario_path(@scenario), :notice => 'Scenario was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    if @scenario.update_attributes(params[:scenario])
      redirect_to(@scenario, :notice => 'Scenario was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @scenario.destroy
    redirect_to(scenarios_url)
  end
  
  private
  
  def find_scenario
    @scenario = current_user.find_scenario(params[:id])
  end
  
end
