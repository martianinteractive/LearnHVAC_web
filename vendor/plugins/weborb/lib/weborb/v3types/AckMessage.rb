# =========================================================================
# AckMessage.rb
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

require 'uuidtools'
require 'weborb/util'
require 'weborb/v3types/v3message'

class AckMessage < V3Message
  
  def initialize(correlationId, clientId, obj)
    self.correlationId = correlationId
    self.clientId = clientId.nil? ? UUID.random_create.to_s.upcase : clientId
    self.messageId = UUID.random_create.to_s.upcase

    #response_metadata = ThreadContext.get_properties().fetch( Constants::RESPONSE_METADATA )

    #if !response_metadata.nil?
    #  self.headers = response_metadata
    #else
    #  self.headers = Hash.new
      
    self.headers = Hash.new
	self.timestamp = TimeUtil.time_in_milliseconds 
	self.body = BodyHolder.new
    self.body.body = obj
    self.timeToLive = 0
    self.isError = false # and ErrMessage will reset this to true later in the construction process
  end
end

