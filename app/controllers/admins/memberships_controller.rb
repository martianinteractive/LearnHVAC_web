class Admins::MembershipsController < Admins::ApplicationController
  
  def destroy
    @membership = GroupMembership.find(params[:id])
    @membership.destroy
    redirect_to admins_class_path(@membership.group)
  end
  
end
