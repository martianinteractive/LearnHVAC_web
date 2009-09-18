
require 'weborb/context'
require 'rbconfig'
require 'md5'

class UserService
  
  # function doLogin
  # checks to see whether login and password are valid, if so, returns the role name for that user. If not, returns false

  def doLogin(login, password)

    user = User.authenticate(login, password)
    APPLOG.info("Login attempt with login: " + login.to_s)
    if user
    
      begin
        #Log activity before returning user
        activity = Activity.new
        activity.action = Action.find_by_name("FlashClientLogin")
        activity.user = User.find_by_login(login)
        activity.value_string = "OK"
        activity.save()
      rescue
        APPLOG.error("Couldn't save activity. doLogin() function. login: " + login.to_s )
      end
      
      #Don't return all user information, just the necessary fields
      u = [user.first_name, user.last_name, user.login, user.role.name]
      u
      
    else
      p "couldn't authenticate login: " + login.to_s
      begin
        #Log activity before returning user
        activity = Activity.new
        activity.action = Action.find_by_name("FlashClientLogin")
        activity.user = User.find_by_login(login)
        activity.value_string = "FAILED"
        activity.save()
      rescue
        APPLOG.error("Couldn't save activity. doLogin() function. login: " + login.to_s )
      end
      
      return nil
    end
      
  end 
  	
	  
end
