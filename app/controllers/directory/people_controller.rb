class Directory::PeopleController < Directory::ApplicationController
  
  def show
    @user = User.find(params[:id])
  end
  
end
