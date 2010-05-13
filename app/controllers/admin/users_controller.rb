class Admin::UsersController < Admin::ApplicationController
  before_filter :get_role
  
  def index
    @users = User.where(:role_code => @role).order('last_name DESC').paginate(:page => params[:page], :per_page => 25)
  end
  
  def list
    @users = User.where(:role_code => @role).order('last_name DESC').paginate(:page => params[:page], :per_page => 25)
    render :layout => false
  end
  
  def search
    conditions = ["role_code = #{@role} AND (first_name LIKE :q OR last_name LIKE :q OR login LIKE :q OR email LIKE :q)", {:q => '%'+params[:q]+'%'}]
    @users = User.where(conditions).order('last_name DESC').paginate(:page => params[:page], :per_page => 25)
    render :action => "index"
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @user.role_code = @role
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(params[:user])
    @user.role_code = params[:user][:role_code]
    @user.enabled = params[:user][:enabled]

    if @user.save
      redirect_to(admin_user_path(@user, :role => params[:role], :anchor => "ui-tabs-1"), :notice => 'User was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @user = User.find(params[:id])
    @user.role_code = params[:user][:role_code]
    @user.enabled = params[:user][:enabled]
    
    if @user.update_attributes(params[:user])
      redirect_to(admin_user_path(@user, :role => params[:role]), :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    role = @user.role
    @user.destroy

    redirect_to admin_users_path(:role => role)
  end
  
  def states
    if params[:state]
      country_code = Carmen::country_code(params[:state])
      @states = Region.where(:country => country_code).order(:value)
      render :partial => 'states'
    else
      render :nothing => true
    end
  end
  
  
  private
  
  def get_role
    raise ArgumentError, "role parameter is required" unless params[:role]
    @role = User::ROLES[params[:role].to_sym]
  end
  
end
