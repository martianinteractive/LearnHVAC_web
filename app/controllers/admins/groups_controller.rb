class Admins::GroupsController < Admins::ApplicationController
  before_filter :build_instructor, :only => [:new, :create]
  
  cache_sweeper :group_sweeper, :only => [:create, :update, :destroy]
  
  add_crumb("Classes") { |instance| instance.send :admins_classes_path }
  
  def index
    @groups_grid = initialize_grid(Group,
                                   :include => { :members => :institution},
                                   :per_page => 25)
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
    add_crumb "New Group", new_admins_class_path
  end

  def edit
    @group = Group.find(params[:id])
    add_crumb "Editing #{@group.name}", edit_admins_class_path(@group)
  end

  def create
    @group = Group.new(params[:group])

    if @group.save
      redirect_to(admins_class_path(@group), :notice => 'Group was successfully created.')
    else
      add_crumb "New Group", new_admins_class_path
      render :action => "new"
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to(admins_class_path(@group), :notice => 'Group was successfully updated.')
    else
      add_crumb "Editing #{@group.name}", edit_admins_class_path(@group)
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
