class AccountsController < ApplicationController
  before_filter :require_no_user
  
  def new
  end
  
  def create
    if params[:role].present? and %w(instructor guest student).include?(params[:role])
      redirect_to send("#{params[:role].pluralize}_signup_path") 
    else
      flash[:notice] = "Please select a role"
      render :action => "new"
    end
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
end
