class Managers::AccessController < Managers::ApplicationController
  before_filter :find_scenario
  
  def show
  end
  
  def create
    @user_scenario = @scenario.user_scenarios.new(:user => current_user, :scenario => @scenario)
    if @user_scenario.save
      flash[:notice] = "You can now download the #{@user_scenario.scenario.name} scenario."
    else
      flash[:notice] = "There were problems while trying to grant you access to this scenario."
    end
    
    redirect_to [:managers, @scenario, :access]
  end
  
  def destroy
  end
  
  private
  
  def find_scenario
    @scenario = current_user.institution.scenarios.find(params[:scenario_id])
  end
  
end
