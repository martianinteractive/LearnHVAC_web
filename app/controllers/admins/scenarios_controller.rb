class Admins::ScenariosController < Admins::ApplicationController
  subject_buttons :scenario, :only => [:index, :show]
  subject_buttons :cancel_scenario, :only => [:new, :edit, :create, :update]
  inner_tabs :scenario_details
  before_filter :find_scenario, :only => [:show, :edit, :access, :update, :destroy]

  add_crumb("Instructor Scenarios") { |instance| instance.send :admins_scenarios_path }
  before_filter :find_scenario, :except => [:index, :list, :create, :new]

  def index
    @scenarios = Scenario.paginate :page => params[:page], :per_page => 25
  end

  def list
    user = User.find(params[:user_id]) if params[:user_id]
    @scenarios = user.created_scenarios if user
    render :layout => false
  end

  def show
    add_crumb @scenario.name, admins_scenario_path(@scenario)
  end

  def new
    @scenario = Scenario.new
    add_crumb "New Scenario", new_admins_scenario_path
  end

  def edit
    add_crumb "Editing #{@scenario.name}", edit_admins_scenario_path(@scenario)
  end

  def create
    @scenario = Scenario.new(params[:scenario])

    if @scenario.save
      redirect_to(admins_scenario_path(@scenario), :notice => 'Scenarios was succesfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @scenario.update_attributes(params[:scenario])
      redirect_to(admins_scenario_path(@scenario), :notice => 'Scenarios was succesfully udpated.')
    else
      add_crumb "Editing #{@scenario.name}", edit_admins_scenario_path(@scenario)
      render :action => "edit"
    end
  end

  def destroy
    @scenario.destroy
    redirect_to(admins_scenarios_url)
  end
 
  private
  
  def find_scenario
    @scenario = Scenario.find(params[:id])
  end

end
