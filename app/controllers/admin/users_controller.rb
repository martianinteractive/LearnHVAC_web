class Admin::UsersController < Admin::ApplicationController
  
  def index
    role = params[:role] ? User::ROLES[params[:role].to_sym] : 0
    @users = User.where(:role_code => role).limit(25).order('last_name DESC').paginate(:page => params[:page])
  end
  
  def search
    role = params[:role] ? User::ROLES[params[:role].to_sym] : 0
    conditions = ["role_code = #{role} AND (first_name LIKE :q OR last_name LIKE :q OR login LIKE :q OR email LIKE :q)", {:q => '%'+params[:q]+'%'}]
    @users = User.where(conditions).limit(25).order('last_name DESC').paginate(:page => params[:page])
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
    @user.enabled = params[:user][:enabled]

    if @user.save
      redirect_to(admin_user_path(@user), :notice => 'User was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @user = User.find(params[:id])
    @user.role_code = params[:user][:role_code]
    @user.enabled = params[:user][:enabled]
    
    if @user.update_attributes(params[:user])
      redirect_to(admin_user_path(@user), :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to(:back)
  end
  
end
