class UserSession < Authlogic::Session::Base
  before_validation :check_enabled
  validate :check_active
  private
  
  def check_enabled
    user = User.find_by_login(login) if login
    errors.add(:base, "Your account has been temporary disabled") if user and !user.enabled?
  end

  def check_active
    user = User.find_by_login(login) if login
    errors.add(:base, "Your account is not active. You should have received an activation email when you first signed up. Please follow the activation email instructions.") if user and !user.active
  end
  
  
end
