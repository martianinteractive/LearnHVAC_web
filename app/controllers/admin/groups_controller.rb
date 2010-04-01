class Admin::GroupsController < Admin::ApplicationController
  
  def index
    @groups = Group.paginate :page => params[:page], :per_page => 25
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
    @group.group_scenarios.build
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(params[:group])

    if @group.save
      redirect_to(admin_group_path(@group), :notice => 'Group was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to(admin_group_path(@group), :notice => 'Group was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    
    redirect_to(admin_groups_path)
  end
  
end
