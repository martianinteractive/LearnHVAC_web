class Api::ApplicationController < ApplicationController
  
  private
  
  def require_http_auth_user
      authenticate_or_request_with_http_basic do |username, password|
        if @current_user = User.find_by_login(username) 
          @current_user.valid_password?(password)
        else
          false
        end
      end
   end
  
  
end
