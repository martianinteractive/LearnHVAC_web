module Admin::UsersHelper
  
  def location_for(user)
    [user.country, user.state, user.city].join(" - ")
  end
  
end
