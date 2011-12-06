class Admins::ScenariosController < Admins::ApplicationController

  layout 'bootstrap'

  before_filter :find_scenario, :only => [:show, :edit, :update, :destroy]

  subject_buttons :scenario, :only => :show
  subject_buttons :cancel_scenario, :only => [:new, :edit, :create, :update]

  inner_tabs :scenario_details


  def index
    @scenarios = Scenario.all(:include => [:master_scenario])
  end

  def list
    user = User.find(params[:user_id]) if params[:user_id]
    @scenarios = user.created_scenarios if user
    render :layout => false
  end

  def show
  end

  def new
    @scenario = Scenario.new(:longterm_start_date => Time.now,
                             :longterm_stop_date => Time.now+7.days,
                             :realtime_start_datetime => Time.now
                             )
  end

  def edit
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
