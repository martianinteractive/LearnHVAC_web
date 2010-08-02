class Managers::ScenariosController < Managers::ApplicationController
  before_filter :find_scenario, :only => [:show, :access]
  add_crumb("Scenarios") { |instance| instance.send :managers_scenarios_path }
  
  def index
    @scenarios = current_user.institution.scenarios.paginate(:page => params[:page], :per_page => 25)
  end
  
  def show
    add_crumb @scenario.name, managers_scenario_path(@scenario)
  end
  
  def access
  end
  
  def list
    @scenarios = current_user.institution.users.instructor.find(params[:user_id]).scenarios if params[:user_id].present?
    render :layout => false
  end
  
  private 
  
  def find_scenario
    @scenario = current_user.institution.scenarios.find(params[:id])
  end
  
end
