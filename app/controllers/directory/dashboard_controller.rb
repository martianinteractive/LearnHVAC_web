class Directory::DashboardController < Directory::ApplicationController
  
  def index
    @recent_institutions = Institution.recent
    @recent_members = User.recent
  end
  
end
