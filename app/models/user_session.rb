class UserSession < Authlogic::Session::Base
  before_validation :check_enabled
  
  private
  
  def check_enabled
    errors.add(:base, "You have been temporary disabled") if login and !User.find_by_login(login).enabled?
  end
  
  
end
