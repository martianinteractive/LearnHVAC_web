class Managers::ScenariosController < Managers::ApplicationController

  layout 'bootstrap'

  before_filter :find_scenario, :only => [:show]

  def index
    @scenarios = current_user.institution.scenarios.paginate(:page => params[:page], :per_page => 25)
  end

  def show
  end

  def list
    @scenarios = current_user.institution.users.instructor.find(params[:user_id]).created_scenarios if params[:user_id].present?
    render :layout => false
  end

  private

  def find_scenario
    @scenario = current_user.institution.scenarios.find(params[:id])
  end

end
