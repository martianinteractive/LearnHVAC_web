class Managers::GroupsController < Managers::ApplicationController
  before_filter :find_group, :only => [:show, :edit, :update, :destroy]
  
  def index
    @groups = current_user.institution.groups.paginate :page => params[:page], :per_page => 25, :order => "users.last_name"
  end
  
  def show
  end
  
  def new
    @instructor = current_user.institution.users.instructor.first
    @group = Group.new(:instructor => @instructor)
  end
  
  def edit
  end
  
  def create
    @group = Group.new(params[:group])

    if @group.save
      redirect_to(managers_group_path(@group), :notice => 'Group was successfully created.')
    else
      @instructor = current_user.institution.users.instructor.find(params[:group][:instructor_id])
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
  
end
