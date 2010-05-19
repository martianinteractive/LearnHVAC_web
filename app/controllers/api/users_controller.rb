class Api::UsersController < Api::ApplicationController
  before_filter :require_http_auth_user

  def show
    @user = @current_user
    respond_to do |format| 
      format.xml { render :xml => @user.to_xml(:only => [:enabled, :email, :first_name, :last_name, :login], :methods => [:role], :include => {:institution => {:only => :name}}) }
    end
  end

end
