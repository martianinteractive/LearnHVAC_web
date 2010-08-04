class Admins::MembershipsController < Admins::ApplicationController
  
  def destroy
    @user = User.find(params[:id])
    @group = Group.find(params[:group_id])
    memberships = @group.memberships.where(:member_id => @user.id)
    memberships.each { |m| m.destroy }
    redirect_to admins_class_path(@group)
  end
  
end
