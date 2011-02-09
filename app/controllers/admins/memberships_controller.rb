class Admins::MembershipsController < Admins::ApplicationController
  
  def destroy
    @group = Group.find(params[:class_id])
    @group.memberships.where(:id => params[:id]).destroy_all
    redirect_to admins_class_path(@group)
  end
  
end
