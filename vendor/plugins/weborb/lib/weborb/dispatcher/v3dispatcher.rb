# =========================================================================
# v3dispatcher.rb
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

require 'weborb/constants'

class V3Dispatcher

  def dispatch( request_message )
    if !is_v3_request( request_message )
      false
    else
      invocations = request_message.body_parts

      for i in 0...invocations.length
        invocation_body = invocations[i]
        array = invocation_body.data_object
        v3message = array[0]
        v3message = v3message.execute( invocation_body )
        invocation_body.response_data_object = v3message
        invocation_body.service_uri = ""
        
        if v3message.isError 
          invocation_body.response_uri << Constants::ONSTATUS
        else
          invocation_body.response_uri << Constants::ONRESULT
        end        
      end
      
      true
    end
  end
  
  private
  
  def is_v3_request( message )
	request_uri = message.get_initial_request_uri
	body = message.get_initial_request_body
	
	if( !request_uri.index( "." ).nil? )
	  false
    elsif( !(body.class == Array) )
	  false
    else
      true
    end
    
  end			
end