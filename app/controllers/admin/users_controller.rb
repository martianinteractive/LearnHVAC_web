class Admin::UsersController < Admin::ApplicationController
  
  def index
    @users = User.paginate :page => params[:page], :per_page => 25, :order => "role_code DESC"
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    @user.role_code = params[:user][:role_code]

    if @user.save
      redirect_to(admin_user_path(@user), :notice => 'User was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @user = User.find(params[:id])
    @user.role_code = params[:user][:role_code]
    
    if @user.update_attributes(params[:user])
      redirect_to(admin_user_url(@user), :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to(admin_users_url)
  end
end
