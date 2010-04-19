class MembershipsController < ApplicationController
  before_filter :require_student, :only => [:create]
  before_filter :require_instructor, :only => [:destroy]
  before_filter :find_group, :only => [:destroy]
  
  def create    
    if @group
      @membership = Membership.find_or_initialize_by_group_id_and_student_id(:group_id => @group.id, :student_id => current_user.id)
      
      if @membership.new_record? and @membership.save
        flash[:notice] = "Registered"
      elsif !@membership.new_record?
        flash[:notice] = "You are already a member of this group."
      end
      redirect_to students_group_path(@group)
    else
      # This is looking through app/views instead of the absolute path.
      render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404
    end
  end
  
  # This destroy could support a student-membership remove as student. 
  # For now only instructors can remove memberships.
  def destroy
    @membership = @group.memberships.find(params[:id])
    @membership.destroy
    redirect_to instructor_group_path(@group) 
  end
  
  private 
  
  def find_group
    @group = current_user.managed_groups.find(params[:group_id])
  end
  
  # This method is re-defined here 'cause it's redirecting
  # to students_signup instead of login.
  def require_student
    @group = Group.find_by_code(params[:code])
    
    if logged_as?(:instructor)
      if current_user == @group.instructor
        flash[:notice] = "You already have joined this group as instructor."
        redirect_to instructor_group_path(@group)
      else
        flash[:notice] = "You need to login as student to join groups."
        redirect_to default_path_for(current_user)
      end
    elsif !logged_as?(:student)
      store_location
      flash[:notice] = "You must be logged in to access this page. Signup or login if you are already a member."
      redirect_to students_signup_path(:code => params[:code])
    end
  end
  
end
