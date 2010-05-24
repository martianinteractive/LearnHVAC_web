class Api::ScenariosController < Api::ApplicationController
  before_filter :require_http_auth_user
  
  def index
    @scenarios = @current_user.groups.collect(&:scenarios).flatten
    if @scenarios.any?
      @scenarios << @current_user.scenarios
    else
      @scenarios = @current_user.scenarios
    end
    respond_to do |format| 
      format.xml
    end
  end
  
  def show
    @scenario = Scenario.find(params[:id])
    respond_to do |format|
      format.xml
    end
  end
  
end
