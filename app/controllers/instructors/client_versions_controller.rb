class Instructors::ClientVersionsController < Instructors::ApplicationController
  def index
    @client_versions = ClientVersion.paginate :page => params[:page], :per_page => 10, :order => "release_date DESC"
  end
end
