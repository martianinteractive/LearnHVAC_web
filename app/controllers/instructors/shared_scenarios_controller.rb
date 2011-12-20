class Instructors::SharedScenariosController < ApplicationController

  layout 'bootstrap'

  before_filter :load_scenarios
  before_filter :load_scenario,  :only => :clone

  def index
  end

  def clone
    @new_scenario = @scenario.clone_for current_user
    if @new_scenario.persisted?
      flash[:notice] = 'Scenario successfully cloned.'
      redirect_to instructors_scenario_path(@new_scenario)
    else
      flash[:error] = 'Scenario could not be clonned.'
      redirect_to :back
    end
  end

  private

  def load_scenario
    @scenario = Scenario.find(params[:id] || params[:shared_scenario_id])
  end

  def load_scenarios
    @scenarios = Scenario.shared.paginate :per_page => 25, :page => params[:page]
  end

end
