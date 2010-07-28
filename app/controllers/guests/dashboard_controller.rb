class Guests::DashboardController < ApplicationController
  before_filter :require_guest
  layout "guests"
  
  def show
    @client_versions = ClientVersion.paginate :page => params[:page], :per_page => 10, :order => "release_date DESC"
  end
  
end
