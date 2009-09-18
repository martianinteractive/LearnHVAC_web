# =========================================================================
# weborb_config.rb
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

require 'weborb/log'
require 'weborb/util'
require 'weborb/mapping'
require 'weborb/config/acl_config'
require 'weborb/config/flex_remoting_config'
require 'weborb/security/weborb_security'
require 'rexml/document'

class ServerClassInfo
  attr_accessor :class_name, :source
end

class WebORBConfig

  def WebORBConfig.init
    Mapping.init_service_mappings
    @@client_mappings = Hash.new
    @@server_mappings = Hash.new
    config_path = "#{RAILS_ROOT}/config/weborb-config.xml"
    file = File.new(config_path)
    config_document = REXML::Document.new(file)
    
    config_element = config_document.root
    mappings_element = config_element.elements['classMappings']
    
    mappings_element.elements.each( 'classMapping' ) do | mapping_element |
      client_class_element = mapping_element.elements['clientClass']
      server_class_element = mapping_element.elements['serverClass']
      source_element = mapping_element.elements['source']
      client_class = client_class_element.get_text.to_s
      server_class = server_class_element.get_text.to_s
      source = source_element.get_text.to_s
      server_class_info = ServerClassInfo.new
      server_class_info.class_name = server_class
      server_class_info.source = source
      @@client_mappings[client_class] = server_class_info
      @@server_mappings[server_class] = client_class
    end
    
    security_element = config_element.elements['security']
    auth_handler_element = security_element.elements['authenticationHandler']
    auth_handler_name = auth_handler_element.get_text.to_s
    auth_handler_class = ClassUtil.load_class( auth_handler_name )
    
    WebORBSecurity.set_auth_handler(auth_handler_class.new)
    WebORBSecurity.init
    
    resources_element = security_element.elements['secureResources']
    
    unless resources_element.nil?
      resources_element.elements.each( 'secureResource' ) do | resource_element |
        destination_id = resource_element.attribute('destinationId').value
        contstraint_name = resource_element.elements['constraintName'].get_text.to_s
        WebORBSecurity.secure_resource(destination_id)
      end
    end
    
    
    AclConfig.configure(config_element)
    FlexRemotingServiceConfig.configure
  end
  
  def WebORBConfig.get_client_mappings
    @@client_mappings
  end
  
  def WebORBConfig.get_server_mappings
    @@server_mappings
  end
end
