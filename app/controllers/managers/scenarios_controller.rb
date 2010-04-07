class Managers::ScenariosController < Managers::ApplicationController
  
  def index
    @scenarios = current_user.institution.scenarios.paginate :page => params[:page], :per_page => 25
  end
  
  def show
    @scenario = current_user.institution.scenarios.find { |s| s.id == params[:id] }
  end
  
  def list
    @scenarios = current_user.institution.users.instructor.find(params[:user_id]).scenarios if params[:user_id]
    render :layout => false
  end
  
end
