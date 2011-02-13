class MembershipsController < ApplicationController
  before_filter :require_student, :only => [:create]
  
  cache_sweeper :membership_sweeper, :only => [:create]
  
  def create    
    if @group
      @membership = @group.memberships.find_or_initialize_by_group_id_and_member_id(:group_id => @group.id, :member_id => current_user.id)
      
      if @membership.new_record? and @group.create_memberships(current_user)
        flash[:notice] = "Registered"
      elsif !@membership.new_record?
        flash[:notice] = @membership.recently_created? ? "Registered" : "You are already a member of this group."
      end
      redirect_to students_class_path(@group)
    else
      # This is looking through app/views instead of the absolute path.
      render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404
    end
  end
  
  private 
    
  # This method is re-defined here 'cause it's redirecting
  # to students_signup instead of login.
  def require_student
    @group = Group.find_by_code(params[:code])
    
    if logged_as?(:instructor)
      if current_user == @group.creator
        flash[:notice] = "You already have joined this group as instructor."
        redirect_to instructors_class_path(@group)
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
