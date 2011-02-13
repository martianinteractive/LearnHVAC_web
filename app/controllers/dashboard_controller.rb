class DashboardController < ApplicationController
  before_filter :require_user
  
  def index
    redirect_to default_path_for(current_user)
  end
end
