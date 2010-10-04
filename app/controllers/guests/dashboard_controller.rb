class Guests::DashboardController < ApplicationController
  before_filter :require_guest_or_token
  layout "guests"
  
  def show
    @client_versions = ClientVersion.paginate :page => params[:page], :per_page => 10, :order => "release_date DESC"
  end
  
  private
  
  def require_guest_or_token
    require_guest if logged_in? or !User.guest.find_by_perishable_token(params[:token])
  end
  
end
