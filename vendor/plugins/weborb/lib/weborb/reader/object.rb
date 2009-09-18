# =========================================================================
# object.rb
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

class ClassInfo
  attr_accessor :has_loose_props, :class_name, :properties, :externalizable
  
  def initialize
    @properties = Array.new
  end

  def add_property( prop_name )
	@properties.push( prop_name )
  end
  
  def get_property_count
	@properties.length
  end

  def get_property( index )
    @properties[ index ]
  end
end

class V3ObjectReader

  def initialize 
    @string_reader = V3StringReader.new
  end

  def read( reader, parse_context )
    ref_id = reader.read_var_integer

	if( (ref_id & 0x1) == 0 )
	  parse_context.get_reference( ref_id >> 1 )
	else  
      class_info = get_class_info( ref_id, reader, parse_context );
      anonymous_object = AnonymousObject.new 
	  return_value = anonymous_object
	  
	  if class_info.externalizable
	    ext_class_name = class_info.class_name 
	    server_class_info = Mapping.get_server_class_info( ext_class_name )
	    class_object = nil
	    
	    if( !server_class_info.nil? )
	      ext_class_name = server_class_info.class_name
          source_path = server_class_info.source
          class_object = ClassUtil.load_class( ext_class_name, source_path )
        else
          class_object = ClassUtil.load_class( ext_class_name )
        end
        
        external_object = class_object.new
        
        if( external_object.respond_to?( :read_external ) )
          return_value = external_object.read_external( reader, parse_context )
          parse_context.add_reference( return_value )
        else
          #throw an error
          message = "The class " + ext_class_name + " must implement a read_external method; " +
            "see weborb/v3types/ObjectProxy.rb for an example."
          Log.error message  
        end
      else
	    parse_context.add_reference( return_value )
	    prop_count = class_info.get_property_count

	    for i in 0...prop_count 
		  key = class_info.get_property( i )
		  property = AmfRequestParser.read_data( reader, parse_context )
		  anonymous_object[ key ] = property
        end
        
	    if class_info.has_loose_props 
		  while( true )
		    property_name = @string_reader.read( reader, parse_context )
		    break if( property_name.nil? || property_name.length == 0 )
		    property = AmfRequestParser.read_data( reader, parse_context )
		  
		    if( property_name == "mx_internal_uid" )
              anonymous_object.internal_id = property
            else
              anonymous_object[ property_name ] = property
            end
		  
          end
        end
        
        if( !class_info.class_name.nil? && class_info.class_name.length > 0 )
		  return_value = NamedObject.new( class_info.class_name, anonymous_object ).default_adapt
        end
	  end
	  
	  return_value
	end
  end
  
  private
  
  def get_class_info( ref_id, reader, parse_context )
    
    if( (ref_id & 0x3) == 1 )
	  return parse_context.get_class_info_reference( ref_id >> 2 )
	end
	
	class_info = ClassInfo.new
	class_info.externalizable = (ref_id & 0x4) == 4
	class_info.has_loose_props = (ref_id & 0x8) == 8			
	class_info.class_name = @string_reader.read( reader, parse_context )
	props_count = ref_id >> 4

	for i in 0...props_count 
	  property = @string_reader.read( reader, parse_context )
	  class_info.add_property( property )
    end
	
	parse_context.add_class_info_reference( class_info )
    class_info
  end
end