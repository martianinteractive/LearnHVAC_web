class Instructors::StudentsController < Instructors::ApplicationController
  before_filter :find_group
    
  def show
    @student = @group.members.find(params[:id])
  end
  
  private
  
  def find_group
    @group = current_user.managed_groups.find(params[:class_id])
  end
end
