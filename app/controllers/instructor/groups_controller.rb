class Instructor::GroupsController < Instructor::ApplicationController
  before_filter :find_group, :only => [:show, :edit, :update, :destroy]
  
  def index
    @groups = current_user.managed_groups.paginate :page => params[:page], :per_page => 25
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
    @group.instructor = current_user
    
    if @group.save
      redirect_to(@group, :notice => 'Group was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to(@group, :notice => 'Group was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    
    redirect_to(groups_url)
  end
  
  private
  
  def find_group
    @group = current_user.managed_groups.find(params[:id])
  end
  
end
