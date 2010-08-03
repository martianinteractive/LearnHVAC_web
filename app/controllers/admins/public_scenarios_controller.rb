class Admins::PublicScenariosController < Admins::ApplicationController
  
  def create
    @user_scenario = UserScenario.new(:user => current_user, :scenario_id => params[:scenario_id])
    flash[:notice] = "You can now download the #{@user_scenario.scenario.name} scenario." if @user_scenario.save
    redirect_to [:access, :admins, @user_scenario.scenario]
  end
  
  def destroy
  end
  
end
