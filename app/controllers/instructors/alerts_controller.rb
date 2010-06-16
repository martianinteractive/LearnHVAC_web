class Instructors::AlertsController < Instructors::ApplicationController  
  
  def index
    @alerts = current_user.unread_scenario_alerts.paginate :page => params[:page], :per_page => 25
  end
  
  def update
    @scenario = Scenario.with_unread_alerts.criteria.id(params[:scenario_id]).first
    @alert = @scenario.scenario_alerts.unread.criteria.id(params[:id]).first
    @alert.update_attributes(:read => true)
    redirect_to :back
  end
  
end
