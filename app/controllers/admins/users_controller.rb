class Admins::UsersController < Admins::ApplicationController
  before_filter :get_role, :add_crumbs
  
  def index
    @users = User.where(:role_code => @role).order('last_name DESC').paginate(:page => params[:page], :per_page => 25)
  end
  
  def search
    @users = User.search(@role, params[:q]).order('last_name DESC').paginate(:page => params[:page], :per_page => 25)
    render :action => "index"
  end
  
  def show
    @user = User.find(params[:id])
    add_crumb @user.name, admins_user_path(@user)
  end

  def new
    @user = User.new
    @user.role_code = @role
    add_crumb "New #{params[:role].humanize}", new_admins_user_path(:role => params[:role])
  end

  def edit
    @user = User.find(params[:id])
    add_crumb "Editing #{@user.name}", edit_admins_user_path(:role => params[:role])
  end
  
  def create
    @user = User.new(params[:user])
    @user.role_code = params[:user][:role_code]
    @user.enabled = params[:user][:enabled]

    if @user.save
      redirect_to(admins_user_path(@user, :role => params[:role], :anchor => "ui-tabs-1"), :notice => 'User was successfully created.')
    else
      add_crumb "New #{params[:role].humanize}", new_admins_user_path(:role => params[:role])
      render :action => "new"
    end
  end

  def update
    @user = User.find(params[:id])
    @user.role_code = params[:user][:role_code] if params[:user][:role_code]
    @user.enabled = params[:user][:enabled] if params[:user][:enabled]
    
    if @user.update_attributes(params[:user])
      redirect_to(admins_user_path(@user, :role => params[:role]), :notice => 'User was successfully updated.')
    else
      add_crumb "Editing #{@user.name}", edit_admins_user_path(:role => params[:role])
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    role = @user.role
    @user.destroy

    redirect_to admins_users_path(:role => role)
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
  
  def add_crumbs
    add_crumb params[:role].pluralize.humanize, admins_users_path(:role => params[:role])
  end
  
end
