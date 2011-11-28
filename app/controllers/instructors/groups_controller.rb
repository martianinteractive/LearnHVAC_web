class Instructors::GroupsController < Instructors::ApplicationController

  layout 'bootstrap'

  before_filter :find_group, :only => [:show, :edit, :update, :destroy]

  cache_sweeper :group_sweeper, :only => [:create, :update, :destroy]

  subject_buttons :group, :only => [:show]
  subject_buttons :cancel_group, :only => [:new, :edit, :create, :update]

  inner_tabs :group_details, :only => [:show, :edit]

  def index
    @groups = current_user.managed_groups.paginate :page => params[:page], :per_page => 25, :include => { :members => :institution }
  end

  def show
  end

  def new
    @group = current_user.managed_groups.build
  end

  def edit
  end

  def create
    @group = Group.new(params[:group])
    @group.creator = current_user

    if @group.save
      redirect_to(instructors_class_path(@group), :notice => 'Group was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @group.update_attributes(params[:group])
      redirect_to(instructors_class_path(@group), :notice => 'Group was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @group.destroy
    redirect_to(instructors_classes_url)
  end

  private

  def find_group
    @group = current_user.managed_groups.find(params[:id])
  end

end
