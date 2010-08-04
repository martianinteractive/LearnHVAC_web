class Managers::MembershipsController < Managers::ApplicationController
  
  def destroy
    group = current_user.institution.groups.find(params[:class_id])
    @memberships = group.memberships.where(:member_id => params[:id])
    @memberships.each { |m| m.destroy }
    redirect_to managers_class_path(group)
  end
  
end
