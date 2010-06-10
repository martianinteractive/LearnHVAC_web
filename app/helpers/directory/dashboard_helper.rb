module Directory::DashboardHelper
  def role_and_institution_for(user)
    user.has_role?(:admin) ? "admin" : "#{user.role} at #{formatted_institution_name(user.institution)}"
  end
end
