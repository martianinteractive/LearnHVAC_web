class Instructors::GroupsController < Instructors::ApplicationController
  before_filter :find_group, :only => [:show, :edit, :update, :destroy]
  add_crumb("Groups") { |instance| instance.send :instructors_groups_path }
  
  def index
    @groups = current_user.managed_groups.paginate :page => params[:page], :per_page => 25, :include => { :students => :institution }
  end

  def show
    add_crumb @group.name, instructors_group_path(@group)
  end

  def new
    @group = current_user.managed_groups.build
    add_crumb "New Group", new_instructors_group_path
  end

  def edit
    add_crumb "Editing #{@group.name}", edit_instructors_group_path
  end

  def create
    @group = Group.new(params[:group])
    @group.instructor = current_user
    
    if @group.save
      redirect_to(instructors_group_path(@group), :notice => 'Group was successfully created.')
    else
      render :action => "new"
      add_crumb "New Group", new_instructors_group_path
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to(instructors_group_path(@group), :notice => 'Group was successfully updated.')
    else
      render :action => "edit"
      add_crumb "Editing #{@group.name}", edit_instructors_group_path
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    
    redirect_to(instructors_groups_url)
  end
  
  private
  
  def find_group
    @group = current_user.managed_groups.find(params[:id])
  end
  
end
