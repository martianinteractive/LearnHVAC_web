class Managers::GroupsController < Managers::ApplicationController
  before_filter :find_group, :only => [:show, :edit, :update, :destroy]
  before_filter :build_instructor, :only => [:new, :create]
  add_crumb("Groups") { |instance| instance.send :managers_groups_path }
  
  def index
    @groups = current_user.institution.groups.paginate :page => params[:page], :per_page => 25, :order => "users.last_name", :include => :students
  end
  
  def show
    add_crumb @group.name, managers_group_path
  end
  
  def new
    @group = Group.new(:instructor => @instructor)
    add_crumb "New Group", new_managers_group_path
  end
  
  def edit
    add_crumb "Editing #{@group.name}", edit_managers_group_path
  end
  
  def create
    @group = Group.new(params[:group])

    if @group.save
      redirect_to(managers_group_path(@group), :notice => 'Group was successfully created.')
    else
      render :action => "new"
    end
  end
  
  def update
    if @group.update_attributes(params[:group])
      redirect_to(managers_group_path(@group), :notice => 'Group was successfully updated.')
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @group.destroy
    redirect_to(managers_groups_path)
  end
  
  
  private
  
  def find_group
    @group = current_user.institution.groups.find(params[:id], :readonly => false)
  end
  
  def build_instructor 
    begin
      @instructor = current_user.institution.users.instructor.find(params[:group][:instructor_id])
    rescue
      @instructor = User.new
    end
  end
  
end
