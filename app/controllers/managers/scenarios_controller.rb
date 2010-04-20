class Managers::ScenariosController < Managers::ApplicationController
  before_filter :find_scenario, :only => [:show, :observers]
  
  def index
    @scenarios = current_user.institution.scenarios.to_a.paginate(:page => params[:page], :per_page => 25)
  end
  
  def show
  end
  
  def observers
  end
  
  def list
    @scenarios = current_user.institution.users.instructor.find(params[:user_id]).scenarios if params[:user_id]
    render :layout => false
  end
  
  private 
  
  def find_scenario
    @scenario = current_user.institution.scenarios.find { |s| s.id == params[:id] }
  end
  
end
