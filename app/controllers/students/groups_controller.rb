class Students::GroupsController < ApplicationController
  before_filter :require_student
  
  def index
    @groups = current_user.groups
  end
  
  def show
    @group = current_user.groups.find(params[:id])
  end
  
end
