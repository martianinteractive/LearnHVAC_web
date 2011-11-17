class Instructors::SharedScenariosController < ApplicationController

  layout 'bootstrap'

  before_filter :load_scenarios, :only => :index
  before_filter :load_scenario,  :only => :clone

  def index
  end

  def clone
    flash[:notice] = 'Scenario successfully cloned.'
    redirect_to instructors_shared_scenarios_path
  end

  private

  def load_scenario
    @scenario = Scenario.find(params[:id] || params[:shared_scenario_id])
  end

  def load_scenarios
    @scenarios = Scenario.shared
  end

end
