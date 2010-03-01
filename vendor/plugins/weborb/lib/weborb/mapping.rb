# =========================================================================
# mapping.rb
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

require 'weborb/config/weborb_config'

class Mapping
  
  def Mapping.init_service_mappings
    @@service_mappings = Hash.new
  end

  def Mapping.get_client_class( server_class )
    server_mappings = WebORBConfig.get_server_mappings
    
    if server_mappings[server_class].nil?
      server_class
    else
      server_mappings[server_class]
    end
  end
  
  def Mapping.get_server_class_info( client_class )
    client_mappings = WebORBConfig.get_client_mappings
    client_mappings[client_class]
  end
  
  def Mapping.add_service_mapping( destination_id, source )
    @@service_mappings[destination_id] = source
  end

  def Mapping.get_service_mapping( destination_id )
    if @@service_mappings[destination_id].nil?
      destination_id
    else
      @@service_mappings[destination_id]
    end
  end
  
end