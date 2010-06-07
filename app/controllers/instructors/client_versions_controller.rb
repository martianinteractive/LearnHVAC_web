class Instructors::ClientVersionsController < Instructors::ApplicationController
  
  def index
    @client_versions = ClientVersion.paginate :page => params[:page], :per_page => 25, :order => "version DESC"
  end
  
end
