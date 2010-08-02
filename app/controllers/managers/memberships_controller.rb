class Managers::MembershipsController < Managers::ApplicationController
  
  def destroy
    group = current_user.institution.groups.find(params[:class_id])
    @membership = group.memberships.find(params[:id])
    @membership.destroy
    redirect_to managers_class_path(group)
  end
  
end
