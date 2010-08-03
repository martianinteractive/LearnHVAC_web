class Admins::AccessController < Admins::ApplicationController
  before_filter :find_scenario
  subject_buttons :scenario, :only => [:show]
  inner_tabs :manage_access
  
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
    @user_scenario = UserScenario.where(:user_id => params[:user_id], :scenario_id => @scenario.id).first
    @user_scenario.destroy
    redirect_to [:admins, @scenario, :access]
  end
  
  private
  
  def find_scenario
    @scenario = Scenario.find(params[:scenario_id])
  end
  
end
