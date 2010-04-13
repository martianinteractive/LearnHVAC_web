class ClientVersionsController < ApplicationController
  before_filter :require_instructor
  
  def index
    @client_versions = ClientVersion.paginate :page => params[:page], :per_page => 25, :order => "version DESC"
  end
  
end
