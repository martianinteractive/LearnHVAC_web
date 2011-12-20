class Instructors::DashboardsController < Instructors::ApplicationController

  layout 'bootstrap'

  def show
    @scenarios = current_user.created_scenarios.paginate :per_page => 25, :page => params[:page]
  end

end
