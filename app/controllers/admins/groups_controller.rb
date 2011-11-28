class Admins::GroupsController < Admins::ApplicationController

  layout 'bootstrap'

  before_filter :build_instructor, :only => [:new, :create]

  cache_sweeper :group_sweeper, :only => [:create, :update, :destroy]

  def index
    @groups = Group.all :include => {:members => :institution}
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group              = Group.new
    @created_scenarios  = @instructor.created_scenarios
  end

  def edit
    @group              = Group.find(params[:id])
    @created_scenarios  = @group.creator.created_scenarios
  end

  def create
    @group = Group.new(params[:group])

    if @group.save
      redirect_to(admins_class_path(@group), :notice => 'Group was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to(admins_class_path(@group), :notice => 'Group was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    redirect_to(admins_classes_path)
  end

  private

  def build_instructor
    @instructor = User.find(params[:group][:creator_id]) if params[:group] and params[:group][:creator_id].present?
    @instructor ||= User.new
  end

end
