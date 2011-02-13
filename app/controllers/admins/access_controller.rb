class Admins::AccessController < Admins::ApplicationController
  before_filter :find_scenario, :add_crumbs
  
  cache_sweeper :membership_sweeper, :only => [:create, :destroy]
  
  caches_action :index,
                :cache_path => proc { |c| c.send(:admins_scenario_accesses_path, @scenario) },
                :if => proc { |c| c.send(:can_cache_action?) }
  
  subject_buttons :scenario, :only => [:show]
  inner_tabs :manage_access
  
  def index
    @memberships = @scenario.memberships.includes(:member).paginate(:page => params[:page], :per_page => 50)
  end
  
  def create
    @individual_membership = IndividualMembership.new(:member => current_user, :scenario => @scenario)
    
    if @individual_membership.save
      flash[:notice] = "You can now download the #{@individual_membership.scenario.name} scenario."
    else
      flash[:notice] = "There were problems while trying to grant you access to this scenario."
    end
    redirect_to [:admins, @scenario, :accesses]
  end
  
  def destroy
    @individual_membership = Membership.find(params[:id])
    @individual_membership.destroy
    redirect_to [:admins, @scenario, :accesses], :notice => "Membership was successfully delete"
  end
  
  private
  
  def find_scenario
    @scenario = Scenario.find(params[:scenario_id])
  end
  
  def add_crumbs
    add_crumb "Scenarios", [:admins, :scenarios]
    add_crumb @scenario.name, [:admins, @scenario]
    add_crumb "Manage Access", [:admins, @scenario, :accesses]
  end
  
end
