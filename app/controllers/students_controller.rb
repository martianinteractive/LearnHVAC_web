class StudentsController < ApplicationController
  before_filter :require_instructor
  before_filter :find_group
    
  def show
    @student = @group.students.find(params[:id])
    @member_since = @student.memberships.where(:group_id => @group.id).first.created_at.to_formatted_s(:long)
  end
  
  private
  
  def find_group
    @group = current_user.managed_groups.find(params[:group_id])
  end
end
