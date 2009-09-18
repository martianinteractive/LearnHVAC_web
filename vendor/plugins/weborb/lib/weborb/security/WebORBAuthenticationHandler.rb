require 'weborb/security/weborb_security'

class WebORBAuthenticationHandler
  def check_credentials( userid, password )
    WebORBSecurity.check_credentials( userid, password )
    true
  end
end