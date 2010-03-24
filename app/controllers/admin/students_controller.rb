class Admin::StudentsController < ApplicationController
  before_filter :require_admin
  before_filter :find_group
  layout "admin"
  
  def index
    @students = @group.students.paginate :page => params[:page], :per_page => 25
  end
  
  private
  
  def find_group
    @group = Group.find(params[:group_id])
  end
end
