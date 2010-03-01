# =========================================================================
# weborb_dispatcher.rb
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
require 'weborb/dispatcher/v3dispatcher'

class WebOrbDispatcher

  def WebOrbDispatcher.init_dispatchers
    @@dispatchers = Array.new
    WebOrbDispatcher.add_dispatcher V3Dispatcher.new
    WebOrbDispatcher.add_dispatcher Invoker.new
  end
  
  def WebOrbDispatcher.add_dispatcher( dispatcher )
    @@dispatchers.push dispatcher
  end
  
  def WebOrbDispatcher.dispatch( request_message )
    processed = false
    
    for i in 0...@@dispatchers.length
      if @@dispatchers[i].dispatch request_message
        processed = true
        break
      end
    end
    
    processed
  end
end

WebOrbDispatcher.init_dispatchers