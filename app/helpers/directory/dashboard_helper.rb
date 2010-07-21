module Directory::DashboardHelper
  def role_and_institution_for(user)
    if user.has_role?(:admin) or user.has_role?(:guest) 
      user.role
    else
      "#{user.role} at #{formatted_institution_name(user.institution)}"
    end
  end
end
