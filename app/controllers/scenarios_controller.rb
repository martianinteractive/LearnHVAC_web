class ScenariosController < ApplicationController
  before_filter :require_http_auth_user
  
  def index
    @scenarios = @user.groups.collect(&:scenarios).flatten
    respond_to do |format| 
      format.xml { render :layout => false } 
    end
  end
  
  def show
  end
  
end
