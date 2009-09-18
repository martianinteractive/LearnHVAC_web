# =========================================================================
# object_writer.rb
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
require 'weborb/log'

class ObjectWriter
  def write_object( object, formatter )
    object_class = object.class
	class_name = object_class.name
	resolved_name = Mapping.get_client_class( class_name )
	
	if Log.info?
      Log.info( "writing object of type: " + class_name + " resolved to " + resolved_name )
    end
	
	object_fields = Hash.new
	object_fields[ "_orbclassname" ] = resolved_name
	attributes = object_class.get_attributes
	
	attributes.each do |attribute|
	  attr_name = attribute.id2name
	  attr_method = object.method attr_name
	  attr_value = attr_method.call
	  object_fields[attr_name] = attr_value
	end
	
	object_serializer = formatter.get_object_serializer
	object_serializer.write_object( resolved_name, object_fields, formatter )
  end
end