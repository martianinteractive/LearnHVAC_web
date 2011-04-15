class Directory::DashboardController < Directory::ApplicationController
  
  def index
    @institutions = Institution.recent
    @users = User.recent.listed_directory
  end
  
end
