class Instructors::AccessController < Instructors::ApplicationController

  layout 'bootstrap'

  before_filter :find_scenario, :add_crumbs
  inner_tabs :manage_access
  subject_buttons :scenario, :only => :show

  cache_sweeper :membership_sweeper, :only => [:destroy]

  def index
    @memberships = @scenario.memberships.includes(:member).paginate(:page => params[:page], :per_page => 50)
  end

  def destroy
    @membership = @scenario.group_memberships.find(params[:id])
    @membership.destroy
    redirect_to([:instructors, @scenario, :accesses], :notice => "Membership was successfully deleted")
  end

  private

  def find_scenario
    @scenario = current_user.created_scenarios.find(params[:scenario_id])
  end

  def add_crumbs
    add_crumb "Scenarios", instructors_scenarios_path
    add_crumb @scenario.name, instructors_scenario_path(@scenario)
    add_crumb "Manage Access", [:instructors, @scenario, :accesses]
  end

end
