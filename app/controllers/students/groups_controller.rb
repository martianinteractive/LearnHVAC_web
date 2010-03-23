class Students::GroupsController < ApplicationController
  before_filter :require_student
  
  def index
    @groups = current_user.groups
  end
  
end
