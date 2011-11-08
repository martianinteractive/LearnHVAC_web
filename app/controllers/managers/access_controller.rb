class Managers::AccessController < Managers::ApplicationController

  layout 'bootstrap'

  before_filter :find_scenario, :add_crumbs

  cache_sweeper :membership_sweeper, :only => [:create, :destroy]

  def index
    @memberships = @scenario.memberships.includes(:member).paginate(:page => params[:page], :per_page => 50)
  end

  def create
    @individual_membership = @scenario.individual_memberships.new(:member => current_user)

    if @individual_membership.save
      flash[:notice] = "You can now download the #{@scenario.name} scenario."
    else
      flash[:notice] = "There were problems while trying to grant you access to this scenario."
    end

    redirect_to [:managers, @scenario, :accesses]
  end

  def destroy
    @membership = @scenario.memberships.non_admin.find(params[:id])
    @membership.destroy
    redirect_to([:managers, @scenario, :accesses])
  end

  private

  def find_scenario
    @scenario = current_user.institution.scenarios.find(params[:scenario_id])
  end

  def add_crumbs
    add_crumb "Scenarios", [:managers, :scenarios]
    add_crumb @scenario.name, [:managers, @scenario]
    add_crumb "Manage Access", [:managers, @scenario, :accesses]
  end

end
