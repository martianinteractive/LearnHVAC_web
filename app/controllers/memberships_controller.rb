class MembershipsController < ApplicationController
  before_filter :require_student
  
  def create
    @group = Group.find_by_code(params[:code])
    
    if @group
      @membership = Membership.find_or_initialize_by_group_id_and_student_id(:group_id => @group.id, :student_id => current_user.id)
      
      if @membership.new_record? and @membership.save
        flash[:notice] = "Registered"
        redirect_to default_path_for(current_user)
      elsif !@membership.new_record?
        flash[:notice] = "You are already a member of this group."
        redirect_to students_group_path(@group)
      end
    else
      # This is looking through app/views instead of the absolute path.
      render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404
    end
  end
  
  private 
  
  # This method is re-defined here 'cause it's redirecting
  # to students_signup instead of login. 
  def require_student
    if current_user and !current_user.has_role?(:student)
      flash[:notice] = "You must be logged in to access this page. Signup or login if you are already a member."
      redirect_to students_signup_path
    end
  end
  
end
