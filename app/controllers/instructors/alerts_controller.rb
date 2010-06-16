class Instructors::AlertsController < Instructors::ApplicationController  
  
  def index
    @alerts = current_user.unread_scenario_alerts.paginate :page => params[:page], :per_page => 25
  end
  
  def update
    @alert = current_user.unread_scenario_alerts.detect { |a| a.id = params[:id] }
    @alert.update_attributes(:read => true)
    redirect_to :back
  end
  
end
