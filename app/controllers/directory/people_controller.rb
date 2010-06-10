class Directory::PeopleController < Directory::ApplicationController
  
  def index
    @users = User.paginate :page => params[:page], :per_page => 25, :order => "created_at DESC"
  end
  
  def show
    @user = User.find(params[:id])
  end
  
end
