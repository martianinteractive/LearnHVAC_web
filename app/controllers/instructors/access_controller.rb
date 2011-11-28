class Instructors::AccessController < Instructors::ApplicationController

  layout 'bootstrap'

  before_filter :find_scenario
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

end
