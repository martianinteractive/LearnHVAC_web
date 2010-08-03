class Admins::AccessController < Admins::ApplicationController
  before_filter :find_scenario
  
  def show
    add_crumb "Access", [:admins, @scenario, :access]
  end
  
  def create
    @user_scenario = UserScenario.new(:user => current_user, :scenario => @scenario)
    
    if @user_scenario.save
      flash[:notice] = "You can now download the #{@user_scenario.scenario.name} scenario."
    else
      flash[:notice] = "There were problems while trying to grant you access to this scenario."
    end
    
    redirect_to [:admins, @scenario, :access]
  end
  
  def destroy
  end
  
  private
  
  def find_scenario
    @scenario = Scenario.find(params[:scenario_id])
  end
  
end
