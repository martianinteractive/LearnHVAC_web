class Instructors::DashboardsController < Instructors::ApplicationController

  layout 'bootstrap'

  def show
    @scenarios = current_user.created_scenarios
  end

end
