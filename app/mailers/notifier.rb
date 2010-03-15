class Notifier < ActionMailer::Base
  ActionMailer::Base.default_url_options[:host] = "lhvac.com"
  default :from => "from@lhvac.com"
    
  def password_reset_instructions(user) 
    @user = user
    mail(:to => user.email, :subject => "Password Reset Instructions")
  end
  
  def activation_instructions(user)
    @user = user
    mail(:to => user.email, :subject => "Activation Instructions")
  end
  
  def activation_confirmation(user)
    @user = user
    mail(:to => user.email, :subject => "Activation Confirmation")
  end
  
end
