class Instructors::SharedScenariosController < ApplicationController

  layout 'bootstrap'

  before_filter :load_scenarios, :only => :index
  before_filter :load_scenario,  :only => :clone
  #before_filter :validate_clonning, :only => :clone

  def index
  end

  def clone
    @new_scenario = @scenario.clone_for current_user
    if @new_scenario.persisted?
      flash[:notice] = 'Scenario successfully cloned.'
    else
      flash[:error] = 'Scenario could not be clonned.'
    end
    redirect_to instructors_shared_scenarios_path
  end

  private

  def validate_clonning
    if @scenario.user == current_user or @scenario.original_author == current_user
      flash[:error] = "You can't clone your own scenario."
      redirect_to instructors_shared_scenarios_path
    end
  end

  def load_scenario
    @scenario = Scenario.find(params[:id] || params[:shared_scenario_id])
  end

  def load_scenarios
    @scenarios = Scenario.shared
  end

end
