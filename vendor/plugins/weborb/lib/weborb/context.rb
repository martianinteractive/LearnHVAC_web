# =========================================================================
# context.rb
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

class RequestContext

  def RequestContext.set_context( request, session )
    @@request = request
    @@session = session
  end
  
  def RequestContext.set_session( session )
    @@session = session
  end
  
  def RequestContext.get_session
    @@session
  end
  
  def RequestContext.set_request( request )
    @@request = request
  end
  
  def RequestContext.get_request
    @@request
  end  
  
  def RequestContext.set_credentials( user_name, password )
    @@session['weborb_flex_user_name'] = user_name
    @@session['weborb_flex_password'] = password
  end 
  
  def RequestContext.get_user_name
    @@session['weborb_flex_user_name']
  end 
  
  def RequestContext.get_password
    @@session['weborb_flex_password']
  end 
end