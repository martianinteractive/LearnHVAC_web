class Managers::ScenariosController < Managers::ApplicationController
  
  def list
    @scenarios = current_user.institution.users.instructor.find(params[:user_id]).scenarios if params[:user_id]
    render :layout => false
  end
  
end
