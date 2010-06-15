class Instructors::ClientVersionsController < Instructors::ApplicationController
    add_crumb("Client Versions") { |instance| instance.send :instructors_client_versions_path }
  
  def index
    @client_versions = ClientVersion.paginate :page => params[:page], :per_page => 25, :order => "version DESC"
  end
  
end
