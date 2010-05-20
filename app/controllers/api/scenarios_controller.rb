class Api::ScenariosController < Api::ApplicationController
  before_filter :require_http_auth_user
  
  def index
    @scenarios = @current_user.groups.collect(&:scenarios).flatten
    respond_to do |format| 
       # format.xml { render :xml => @scenarios.to_xml(:skip_internals => true, :methods => [:id, :scenario_variables], :include => {:scenario_variables => {}}) }
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
