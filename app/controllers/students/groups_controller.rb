class Students::GroupsController < Students::ApplicationController
  add_crumb("Classes") { |instance| instance.send :students_classes_path }
  
  def index
    @groups = current_user.groups.paginate :page => params[:page], :per_page => 25
  end
  
  def show
    @group = current_user.groups.find(params[:id])
    add_crumb @group.name, students_class_path(@group)
  end
  
end
