# =========================================================================
# amfv0_formatter.rb
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
require 'weborb/io/binary_writer'
require 'weborb/writer/amf_formatter'
require 'weborb/writer/object_serializer'
require 'date'

class AmfV0Formatter < AmfFormatter

  def initialize
    @writer = BinaryWriter.new
    super(@writer, ObjectSerializer.new)
  end

  def write_number( number )
    @writer.write_byte( Datatypes::NUMBER_DATATYPE_V1 )
    @writer.write_double( number )
  end

  def write_boolean( boolean )
    @writer.write_byte( Datatypes::BOOLEAN_DATATYPE_V1 )
    direct_write_boolean( boolean )
  end

  def write_string( string )
    @writer.write_utf( string, false, true )
  end
  
  def write_xml( xml_document )
    @writer.write_byte( Datatypes::PARSEDXML_DATATYPE_V1 )
    #NOTE: this may be wrong... see the getEncoded method in the .Net version
    @writer.write_utf( xml_document.to_s, false, true )
  end
  
  def write_null
    @writer.write_byte( Datatypes::NULL_DATATYPE_V1 )
  end

  def write_date( datetime )
  
    if( datetime.class == Date )
      datetime = Time.gm( datetime.year, datetime.month, datetime.day )
    elsif( datetime.class == DateTime )
      datetime = Time.gm( datetime.year, datetime.month, datetime.day, datetime.hour, datetime.min, datetime.sec )      
    end

    datetime.utc unless datetime.utc?
    milli_seconds = datetime.to_i * 1000 + ( datetime.usec/1000 )
    
    @writer.write_byte( Datatypes::DATE_DATATYPE_V1 )
    @writer.write_double( milli_seconds )
    @writer.write_short( 0 )
  end
  
  def begin_write_body_content
  end

  def end_write_body_content
  end
  
  def begin_write_array( length )
    @writer.write_byte( Datatypes::ARRAY_DATATYPE_V1 )
    @writer.write_int( length )
  end

  def begin_write_object( field_count )
    @writer.write_byte( Datatypes::OBJECT_DATATYPE_V1 )
  end
  
  def end_write_object
    @writer.write_byte 0
    @writer.write_byte 0
    @writer.write_byte( Datatypes::ENDOFOBJECT_DATATYPE_V1 )
  end
  
  def write_field_name( field_name )
    @writer.write_utf( field_name, false )
  end

  def begin_write_named_object( class_name, field_count )
    @writer.write_byte( Datatypes::NAMEDOBJECT_DATATYPE_V1 )
    @writer.write_utf( class_name, false )
  end
  
  def begin_write_object_map( field_count )
    @writer.write_byte( Datatypes::OBJECTARRAY_DATATYPE_V1 )
    @writer.write_int( field_count )
  end
  
  def write_anonymous_obj( anonymous_obj )
    property_bag = anonymous_obj.properties
    full_name = anonymous_obj.class.get_full_name
    
    #if data_object.full_name.nil?
    if full_name.nil?
	  begin_write_object( property_bag.length )
	
	  property_bag.each do |key, value| 
        write_field_name key.to_s
        MessageWriter.write_object( value, self )
      end

      end_write_object
    else
      puts "writing anonymous object with type name of: " + full_name
      object_serializer = get_object_serializer
	  object_serializer.write_object( full_name, property_bag, self )
    end
  end
  
end