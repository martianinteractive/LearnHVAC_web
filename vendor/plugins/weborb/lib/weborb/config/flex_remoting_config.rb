# =========================================================================
# flex_remoting_config.rb
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

require 'weborb/mapping'
require 'rexml/document'

class FlexRemotingServiceConfig

  def FlexRemotingServiceConfig.configure
    config_path = "#{RAILS_ROOT}/config/WEB-INF/flex/remoting-config.xml"
    file = File.new(config_path)
    config_document = REXML::Document.new(file)
    service_element = config_document.root
    
    service_element.elements.each( 'destination' ) do | destination_element |
      destination_id = destination_element.attribute('id').value
      properties_element = destination_element.elements['properties']
      source = properties_element.elements['source'].get_text.to_s
      
      #TODO: finish handling SCOPE
      #scope_element = properties_element.elements['scope']
	  #scope = scope_element.get_text.to_s unless scope_element.nil?
	  Mapping.add_service_mapping( destination_id, source )
    end
  end
end