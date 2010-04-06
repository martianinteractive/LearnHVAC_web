module Admin::UsersHelper
  
  def formatted_role(format = :long)
    if session[:role]
      format == :long ? session[:role].gsub("_", " ").capitalize : session[:role].split("_").last.capitalize
    else
      "User"
    end
  end
  
end
