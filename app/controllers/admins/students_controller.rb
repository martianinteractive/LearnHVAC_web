class Admins::StudentsController < Admins::ApplicationController
  before_filter :find_group
  
  def index
    @students = @group.students.paginate :page => params[:page], :per_page => 25
  end
  
  private
  
  def find_group
    @group = Group.find(params[:group_id])
  end
end
