class UsersController < ApplicationController
  before_filter :require_http_auth_user

  def show
    @user = current_user
    respond_to do |format| 
      format.xml { render :xml => @user.to_xml }
      # format.xml { render :layout => false } 
    end
  end

end
