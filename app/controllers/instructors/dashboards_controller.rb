class Instructors::DashboardsController < Instructors::ApplicationController
  
  def show
    @unreviewed_scenarios = current_user.scenarios.with_unread_alerts
  end
  
end
