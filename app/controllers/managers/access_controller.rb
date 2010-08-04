class Managers::AccessController < Managers::ApplicationController
  before_filter :find_scenario, :add_crumbs
  
  def show
  end
  
  def create
    @individual_membership = @scenario.individual_memberships.new(:member => current_user)
    
    if @individual_membership.save
      flash[:notice] = "You can now download the #{@scenario.name} scenario."
    else
      flash[:notice] = "There were problems while trying to grant you access to this scenario."
    end
    
    redirect_to [:managers, @scenario, :access]
  end
  
  def destroy
    user = current_user.institution.users.non_admin.find(params[:member_id])
    @individual_membership = @scenario.individual_memberships.where(:member_id => user.id, :scenario_id => @scenario.id).first
    @individual_membership.destroy
    redirect_to([:managers, @scenario, :access])
  end
  
  private
  
  def find_scenario
    @scenario = current_user.institution.scenarios.find(params[:scenario_id])
  end
  
  def add_crumbs
    add_crumb "Scenarios", [:managers, :scenarios]
    add_crumb @scenario.name, [:managers, @scenario]
    add_crumb "Manage Access", [:managers, @scenario, :access]
  end
  
end
