class Instructors::MembershipsController < Instructors::ApplicationController
  
  def destroy
    group = current_user.managed_groups.find(params[:class_id])
    @membership = group.memberships.for_students.find(params[:id])
    @membership.destroy
    redirect_to instructors_class_path(group)
  end
  
end
