class UserSweeper < ActionController::Caching::Sweeper
  
  observe User
  
  def after_save(user)
    expire_action("profile/#{user.login}")
  end
  
  def after_destroy(user)
    expire_action("profile/#{user.login}")
  end
  
end
