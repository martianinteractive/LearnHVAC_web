class Admins::MembershipsController < Admins::ApplicationController
  
  def destroy
    @group = Group.find(params[:class_id])
    memberships = @group.memberships.where(:member_id => params[:id])
    memberships.each { |m| m.destroy }
    redirect_to admins_class_path(@group)
  end
  
end
