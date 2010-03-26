class Admin::UsersController < Admin::ApplicationController
  before_filter :set_role, :only => [:index, :search]
  
  def index
    @users = User.send(session[:role] || :all).paginate :page => params[:page], :per_page => 25, :order => "role_code DESC"
  end
  
  def search
    collection = session[:role] ? User.send(params[:role]) : User
    @users = collection.search(params[:q]).paginate :page => params[:page], :order => "role_code DESC"
    render :action => "index"
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
      redirect_to(admin_user_path(@user), :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to(admin_users_url(:role => session[:role]))
  end
  
  private
  
  def set_role
    if params[:role] and User::ROLES.keys.include?(params[:role].to_sym)
      session[:role] = params[:role]
    else
      session[:role] = nil
    end
  end
  
end
