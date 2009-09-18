# =========================================================================
# amfv3_formatter.rb
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

require 'weborb/util'
require 'weborb/constants'
require 'weborb/io/binary_writer'
require 'weborb/writer/amf_formatter'
require 'weborb/writer/v3_object_serializer'
require 'date'

class AmfV3Formatter < AmfFormatter
  
  def initialize
    @writer = BinaryWriter.new
    super(@writer, V3ObjectSerializer.new)
  end

  def write_number( number )
    if( NumberUtil.is_integer( number ) )
      @writer.write_byte( Datatypes::INTEGER_DATATYPE_V3 )
      number = number.to_i 
      @writer.write_var_int( number & 0x1fffffff )
    else
      @writer.write_byte( Datatypes::DOUBLE_DATATYPE_V3 )
      @writer.write_double( number )
    end
  end
 
  def write_boolean( boolean )
    if( boolean )
      @writer.write_byte( Datatypes::BOOLEAN_DATATYPE_TRUEV3 )
    else
      @writer.write_byte( Datatypes::BOOLEAN_DATATYPE_FALSEV3 )
    end
  end
  
  def write_string( string )
    @writer.write_byte( Datatypes::UTFSTRING_DATATYPE_V3 )
    @writer.write_utf( string, true, false )
  end

  def write_xml( xml_document )
    @writer.write_byte( Datatypes::LONGXML_DATATYPE_V3 )
    @writer.write_utf( xml_document.to_s, true, false )
  end

  def write_null
    @writer.write_byte( Datatypes::NULL_DATATYPE_V3 )
  end

  def write_date( datetime )
    @writer.write_byte( Datatypes::DATE_DATATYPE_V3 )
    @writer.write_var_int( 0x1 )
    
    if( datetime.class == Date )
      datetime = Time.gm( datetime.year, datetime.month, datetime.day )
    elsif( datetime.class == DateTime )
      datetime = Time.gm( datetime.year, datetime.month, datetime.day, datetime.hour, datetime.min, datetime.sec )      
    end
    
    datetime.utc unless datetime.utc?
    total_milliseconds = datetime.to_i * 1000 + ( datetime.usec/1000 )
    @writer.write_double( total_milliseconds )
  end  

  def begin_write_body_content
	@writer.write_byte( Datatypes::V3_DATATYPE )
  end

  def end_write_body_content
  end

  def begin_write_array( length )
    @writer.write_byte( Datatypes::ARRAY_DATATYPE_V3 )
    @writer.write_var_int( length << 1 | 0x1 )
    @writer.write_var_int( 0x1 )
  end
  
  def begin_write_object( field_count )
    @writer.write_byte( Datatypes::OBJECT_DATATYPE_V3 )
    @writer.write_var_int( 0x3 | field_count << 4 )
    @writer.write_var_int( 0x1 )
  end
  
  def end_write_object
  end
  
  def write_field_name( field_name )
    @writer.write_utf( field_name, true )
  end
  
  def begin_write_named_object( class_name, field_count )
    @writer.write_byte( Datatypes::OBJECT_DATATYPE_V3 )
    @writer.write_var_int( 0x3 | field_count << 4 )
    
    if class_name.nil?
      @writer.write_var_int( 1 );
	else
	  @writer.write_utf( class_name, true )
	end  
  end
  
  def begin_write_object_map( field_count )
    @writer.write_byte( Datatypes::OBJECT_DATATYPE_V3 )
    @writer.write_var_int( 0x3 | field_count << 4 )
    @writer.write_var_int( 1 )
  end  
  
  def write_anonymous_obj( anonymous_obj )
    property_bag = anonymous_obj.properties
    object_serializer = get_object_serializer
	object_serializer.write_object( nil, property_bag, self )
  end
end