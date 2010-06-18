class Admins::GroupsController < Admins::ApplicationController
  before_filter :build_instructor, :only => [:new, :create]
  add_crumb("Groups") { |instance| instance.send :admins_groups_path }
  
  def index
    @groups = Group.paginate :page => params[:page], :per_page => 25, :include => { :students => :institution }
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
    add_crumb "New Group", new_admins_group_path
  end

  def edit
    @group = Group.find(params[:id])
    add_crumb "Editing #{@group.name}", edit_admins_group_path(@group)
  end

  def create
    @group = Group.new(params[:group])

    if @group.save
      redirect_to(admins_group_path(@group), :notice => 'Group was successfully created.')
    else
      add_crumb "New Group", new_admins_group_path
      render :action => "new"
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to(admins_group_path(@group), :notice => 'Group was successfully updated.')
    else
      add_crumb "Editing #{@group.name}", edit_admins_group_path(@group)
      render :action => "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    
    redirect_to(admins_groups_path)
  end
  
  private
  
  def build_instructor
    @instructor = User.find(params[:group][:instructor_id]) if params[:group] and params[:group][:instructor_id].present?
    @instructor ||= User.new 
  end
  
end
