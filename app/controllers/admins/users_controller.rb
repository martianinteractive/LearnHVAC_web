class Admins::UsersController < Admins::ApplicationController
  before_filter :get_role, :except =>  [:list_groups]
  before_filter :add_crumbs, :except =>  [:list_groups]
  before_filter :get_list_instructors
  
  cache_sweeper :user_sweeper, :only => [:create, :update, :destroy]
  
  caches_action :index,
                :cache_path => proc { |c| c.send(:admins_users_path, :role => c.params[:role]) }, 
                :if => proc { |c| c.send(:can_cache_action?) }
  
  def index
    @users = User.where(:role_code => @role).includes(:institution).order('last_name DESC').paginate(:page => params[:page], :per_page => 25)
  end
  
  def search
    @users = User.search(@role, params[:q]).paginate(:page => params[:page], :per_page => 25)
    render :action => :index
  end
  
  def filter
    @users = User.filter(@role, params[:institution_id]).paginate(:page => params[:page], :per_page => 25)
    render :action => :index
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
    @instructors = User.instructor.to_a
    add_crumb "Editing #{@user.name}", edit_admins_user_path(:role => params[:role])
  end
  
  def create
    @user = User.new(params[:user])
    @user.role_code = params[:user][:role_code]
    @user.enabled = params[:user][:enabled]
    @user.group_code = params[:user][:group_code]
    
    if @user.save 
      Group.find_by_code(@user.group_code).create_memberships(@user) if @user.has_role?(:student)
      redirect_to(admins_user_path(@user, :role => params[:role], :group=>@groups, :anchor => "ui-tabs-1"), :notice => 'User was successfully created.')
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

  def list_groups
    @groups=User.find_by_id(params[:id]).managed_groups
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
