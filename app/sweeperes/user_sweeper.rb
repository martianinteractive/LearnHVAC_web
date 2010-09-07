class UserSweeper < ActionController::Caching::Sweeper
  
  observe User
  
  def after_save(user)
    expire_action("profile/#{user.login}")
    expire_action(admins_users_path(:role => user.role))
  end
  
  def after_destroy(user)
    expire_action("profile/#{user.login}")
    expire_action(admins_users_path(:role => user.role))
  end
  
end
