class Notifier < ActionMailer::Base
  ActionMailer::Base.default_url_options[:host] = Site.config["host"]
  default :from => Site.config["from"]
    
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
