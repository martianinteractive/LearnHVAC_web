class UserSession < Authlogic::Session::Base
  before_validation :check_enabled
  
  private
  
  def check_enabled
    user = User.find_by_login(login) if login
    errors.add(:base, "Your account has been temporary disabled") if user and !user.enabled?
  end
  
  
end
