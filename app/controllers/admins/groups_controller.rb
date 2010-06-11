class Admins::GroupsController < Admins::ApplicationController
  before_filter :build_instructor, :only => [:new, :create]
  
  def index
    @groups = Group.paginate :page => params[:page], :per_page => 25
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(params[:group])

    if @group.save
      redirect_to(admins_group_path(@group), :notice => 'Group was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to(admins_group_path(@group), :notice => 'Group was successfully updated.')
    else
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