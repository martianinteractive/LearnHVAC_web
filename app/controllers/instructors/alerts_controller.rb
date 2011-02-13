class Instructors::AlertsController < Instructors::ApplicationController  
  before_filter :find_scenario
  
  def index
    add_crumb("Notifications")
    @alerts = @scenario.scenario_alerts.unread.paginate :page => params[:page], :per_page => 25
  end
  
  def update
    @alert = @scenario.scenario_alerts.unread.criteria.id(params[:id]).first
    @alert.update_attributes(:read => true)
    redirect_to :back
  end
  
  private
  
  def find_scenario
    @scenario = current_user.created_scenarios.with_unread_alerts.criteria.id(params[:scenario_id]).first
    add_crumb(@scenario.name, instructors_scenario_path(@scenario))
  end
  
end
