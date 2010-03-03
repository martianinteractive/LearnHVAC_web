class Notifier < ActionMailer::Base
  default :from => "from@lhvac.com"
  # default :host => "lhvac.com" #doesn't seem to work like default :from
  default_url_options[:host] = "lhvac.com"
  
  def password_reset_instructions(user)  
    subject       "Password Reset Instructions"  
    recipients    user.email  
    sent_on       Time.now  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end
  
end
