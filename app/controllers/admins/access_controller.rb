class Admins::AccessController < Admins::ApplicationController
  before_filter :find_scenario, :add_crumbs
  subject_buttons :scenario, :only => [:show]
  inner_tabs :manage_access
  
  def show
    @memberships = @scenario.memberships.includes(:member).paginate(:page => params[:page], :per_page => 50)
  end
  
  def create
    @individual_membership = IndividualMembership.new(:member => current_user, :scenario => @scenario)
    
    if @individual_membership.save
      flash[:notice] = "You can now download the #{@individual_membership.scenario.name} scenario."
    else
      flash[:notice] = "There were problems while trying to grant you access to this scenario."
    end
    redirect_to [:admins, @scenario, :access]
  end
  
  def destroy
    @individual_membership = IndividualMembership.find(params[:id])
    @individual_membership.destroy
    redirect_to [:admins, @scenario, :access]
  end
  
  private
  
  def find_scenario
    @scenario = Scenario.find(params[:scenario_id])
  end
  
  def add_crumbs
    add_crumb "Scenarios", [:admins, :scenarios]
    add_crumb @scenario.name, [:admins, @scenario]
    add_crumb "Manage Access", [:admins, @scenario, :access]
  end
  
end
