class Admins::Settings::ClientVersionsController < Admins::Settings::BaseController
  add_crumb("Client Versions") { |instance| instance.send :admins_settings_client_versions_path }
  
  def index
    @client_versions = ClientVersion.paginate :page => params[:page], :per_page => 25, :order => "version DESC"
  end

  def show
    @client_version = ClientVersion.find(params[:id])
    add_crumb "Version #{@client_version.version}", admins_settings_client_version_path(@client_version)
  end
  
  def new
    @client_version = ClientVersion.new
    add_crumb "New Version", new_admins_settings_client_version_path
  end
  
  def edit
    @client_version = ClientVersion.find(params[:id])
    add_crumb "Edit Version #{@client_version.version}", edit_admins_settings_client_version_path(@client_version)
  end
  
  def create
    @client_version = ClientVersion.new(params[:client_version])
  
    if @client_version.save
      redirect_to(admins_settings_client_version_path(@client_version), :notice => 'Version was successfully created.')
    else
      render :action => "new"
    end
  end
  
  def update
    @client_version = ClientVersion.find(params[:id])
  
    if @client_version.update_attributes(params[:client_version])
      redirect_to(admins_settings_client_version_path(@client_version), :notice => 'Version was successfully updated.')
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @client_version = ClientVersion.find(params[:id])
    @client_version.destroy
    
    redirect_to(admins_settings_client_versions_path)
  end
  
end
