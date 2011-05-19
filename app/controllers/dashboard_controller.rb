class DashboardController < ApplicationController
  before_filter :require_user
  before_filter :title
  
  def index
    redirect_to default_path_for(current_user)
  end
  
  
  helper_method :title
  
  private
  
  def title
    @title ||= "dashboard"
  end
  
end
