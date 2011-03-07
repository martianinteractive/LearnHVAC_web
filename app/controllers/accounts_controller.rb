class AccountsController < ApplicationController
  # ssl_required :new, :create, :colleges, :states
  layout 'registration'
  before_filter :require_no_user, :except => [:states]
  before_filter :get_role, :only => [:create]
  
  def new
    @account = User.new
  end
  
  def create
    @account = User.new(params[:user])
    @account.active = false
    @account.role_code = @role
    @account.require_agreement_acceptance!
    
    if @account.save_without_session_maintenance
      @account.deliver_activation_instructions!
      flash[:notice] = "Please check your email inbox for account activation instructions. You cannot login until you have clicked on the activation link within the mail you received."
      redirect_to @account.has_role?(:instructor) ? login_path : guests_dashboard_path(:token => @account.perishable_token)
    else
      render :action => :new
    end
  end
  
  def colleges
    if params[:term]
      @colleges = College.find(:all, :conditions => [ "LOWER(value) LIKE ?", '%' + params[:term].downcase + '%' ], :order => "value ASC", :limit => 10)
    end
    
    if @colleges && @colleges.any?
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
  
  def terms
    render :layout => 'signin'
  end
  
  private
  
  def get_role
    role = params[:user][:role_code].try(:to_i)
    @role = role if role and [User::ROLES[:instructor], User::ROLES[:guest]].include?(role)
  end
  
end
