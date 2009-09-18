# =========================================================================
# ReqMessage.rb
# Copyright (C) 2006 Midnight Coders, LLC
#
# ruby adaptation, design and implementation: 
#      Harris Reynolds (harris@themidnightcoders.com)
# original design: 
#      Mark Piller (mark@themidnightcoders.com)
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# The software is licensed under the GNU General Public License (GPL)
# For details, see http://www.gnu.org/licenses/gpl.txt.
# =========================================================================

require 'weborb/dispatcher/invoker'
require 'weborb/security/weborb_security'
require 'weborb/v3types/v3message'
require 'weborb/v3types/AckMessage'
require 'weborb/v3types/ErrMessage'

class ReqMessage < V3Message
  attr_accessor :operation, :messageRefType
  
  def execute( request_message )
  
    if( operation == 5 || operation == 0 || operation == 2 )
      AckMessage.new( messageId, clientId, nil )
    elsif( operation == 8 )
      credentials = Base64.decode64( body ).split(":")
      userid = credentials[0]
      password = credentials[1]
      auth_handler = WebORBSecurity.get_auth_handler
      
      begin
        raise "Invalid credentials" if !auth_handler.check_credentials( userid, password )
        RequestContext.set_credentials( userid, password )                
        return AckMessage.new( messageId, clientId, nil )
      rescue Exception => exception
	    error_message = ErrMessage.new( messageId, exception )
	    error_message.faultCode = "Client.Authentication";
	    return error_message
      end
    else
      arguments = body

      begin
      
        if WebORBSecurity.resource_secure?(destination)
          userid = RequestContext.get_user_name
          password = RequestContext.get_password
          auth_handler = WebORBSecurity.get_auth_handler
          if userid.nil? or password.nil? or !auth_handler.check_credentials( userid, password )
            raise "WebORB security has rejected access to service: " + destination + ". See server log or contact the system administrator"
          end
        end
        
        returnValue = Invoker.handle_invoke( request_message, destination, operation, arguments )
	    AckMessage.new( messageId, clientId, returnValue )
      rescue Exception => exception
        if Log.error?
          message = "Exception processing request.  Destination: " + destination + ", operation: " + operation + ", message: " + exception.message + "\n" + exception.backtrace.join("\n")
          Log.error( message )
        end
         
	    ErrMessage.new( messageId, exception )
      end
    end
    
  end    
end