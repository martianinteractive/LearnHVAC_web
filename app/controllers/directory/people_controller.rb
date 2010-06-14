class Directory::PeopleController < Directory::ApplicationController
  add_crumb("People") { |instance| instance.send :directory_people_path }
  
  def index
    @users = User.paginate :page => params[:page], :per_page => 25, :order => "created_at DESC"
  end
  
  def show
    @user = User.find(params[:id])
    add_crumb @user.name, admins_institution_path(@user)
  end
  
end
