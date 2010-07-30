class Managers::MembershipsController < Managers::ApplicationController
  
  def destroy
    @membership = current_user.institution.groups.find(params[:group_id]).memberships.find(params[:id])
    @membership.destroy
    redirect_to managers_class_path(@membership.group)
  end
  
end
