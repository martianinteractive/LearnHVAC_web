class Instructors::ScenariosController < Instructors::ApplicationController

  layout 'bootstrap'

  before_filter :find_scenario, :only => [:show, :edit, :access, :update, :destroy]

  cache_sweeper :scenario_sweeper, :only => [:create, :update, :destroy]

  subject_buttons :scenario, :only => :show
  subject_buttons :cancel_scenario, :only => [:new, :edit, :create, :update]

  inner_tabs :scenario_details

  def index
    @scenarios = current_user.created_scenarios.paginate :page => params[:page], :per_page => 25
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
    @scenario.user = current_user

    if @scenario.save
      redirect_to instructors_scenario_path(@scenario), :notice => 'Scenario was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    if @scenario.update_attributes(params[:scenario])
      redirect_to instructors_scenario_path(@scenario), :notice => 'Scenario was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @scenario.destroy
    redirect_to(instructors_scenarios_url)
  end

  private

  def find_scenario
    if @scenario = Scenario.find(params[:id])
      if current_user != @scenario.user
        unless @scenario.shared?
          flash[:warning] = 'You are not allowed to access to that scenario.'
          redirect_to instructors_scenarios_path
        end
      end
    else
      flash[:error] = 'The scenario you are looking for does not exist.'
      redirect_to instructors_scenarios_path
    end
  end

end
