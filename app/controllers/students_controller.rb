class StudentsController < ApplicationController
  before_filter :require_instructor
  before_filter :find_group
  
  def index
    @students = @group.students
  end
  
  private
  
  def find_group
    @group = current_user.managed_groups.find(params[:group_id])
  end
end
