class AccountsController < ApplicationController
  
  def new
    @account = User.new
  end
  
  def colleges
    if params[:term]
      @colleges = College.find(:all, :conditions => [ "LOWER(value) LIKE ?", '%' + params[:term].downcase + '%' ], :order => "value ASC", :limit => 10)
    end
    
    if @colleges.any?
      render :js => @colleges.map(&:value).to_json
    else
      render :nothing => true
    end
  end
  
  def states
    if params[:state]
      country_code = Carmen::country_code(params[:state])
      @states = Region.where(:country => country_code).order(:value)
      render :partial => 'states'
    else
      render :nothing => true
    end
  end
  
  
  # Saving without session maintenance to skip
  # auto-login which can't happen here because
  # the User has not yet been activated
  def create
    @account = User.new(params[:user])
    @account.active = false
    @account.role_code = User::ROLES[:instructor]
    
    if @account.save_without_session_maintenance
      @account.deliver_activation_instructions!
      flash[:notice] = "Your account has been created. Before login you have to activate your account. Please check your e-mail for account activation instructions!"
      redirect_to login_path
    else
      render :action => :new
    end
  end
  
end
