# =========================================================================
# amf_request_parser.rb
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
require 'weborb/io/binary_reader'
require 'weborb/message/request'
require 'weborb/reader/number'
require 'weborb/reader/named'
require 'weborb/reader/anonymous'
require 'weborb/reader/boolean'
require 'weborb/reader/bytes'
require 'weborb/reader/string'
require 'weborb/reader/null'
require 'weborb/reader/endofobject'
require 'weborb/reader/array'
require 'weborb/reader/object'
require 'weborb/reader/pointer'
require 'weborb/reader/date'
require 'weborb/reader/remote'
require 'weborb/reader/undefined'
require 'weborb/reader/xml'
require 'weborb/reader/v3'
require 'weborb/writer/amfv0_formatter'
require 'weborb/writer/amfv3_formatter'
require 'weborb/log'

class AmfRequestParser

  def AmfRequestParser.init_readers
    @@readers_v1 = Array.new(Datatypes::TOTAL_V1TYPES)
    @@readers_v1[Datatypes::NUMBER_DATATYPE_V1] = NumberReader.new
    @@readers_v1[Datatypes::BOOLEAN_DATATYPE_V1] = BooleanReader.new
    @@readers_v1[Datatypes::UTFSTRING_DATATYPE_V1] = UTFStringReader.new
    @@readers_v1[Datatypes::OBJECT_DATATYPE_V1] = AnonymousObjectReader.new
    @@readers_v1[Datatypes::NULL_DATATYPE_V1] = NullReader.new
    @@readers_v1[Datatypes::POINTER_DATATYPE_V1] = PointerReader.new
    @@readers_v1[Datatypes::OBJECTARRAY_DATATYPE_V1] = BoundPropertyBagReader.new
    @@readers_v1[Datatypes::ENDOFOBJECT_DATATYPE_V1] = EndReader.new
    @@readers_v1[Datatypes::UNKNOWN_DATATYPE_V1] = UndefinedReader.new
    @@readers_v1[Datatypes::ARRAY_DATATYPE_V1] = ArrayReader.new
    @@readers_v1[Datatypes::DATE_DATATYPE_V1] = DateReader.new
    @@readers_v1[Datatypes::LONGUTFSTRING_DATATYPE_V1] = LongUTFStringReader.new
    @@readers_v1[Datatypes::REMOTEREFERENCE_DATATYPE_V1] = RemoteReferenceReader.new
    @@readers_v1[Datatypes::RECORDSET_DATATYPE_V1] = nil
    @@readers_v1[Datatypes::PARSEDXML_DATATYPE_V1] = XmlReader.new
    @@readers_v1[Datatypes::NAMEDOBJECT_DATATYPE_V1] = NamedObjectReader.new
    @@readers_v1[Datatypes::V3_DATATYPE] = V3Reader.new
    
    @@readers_v3 = Array.new(Datatypes::TOTAL_V3TYPES)
    @@readers_v3[Datatypes::UNKNOWN_DATATYPE_V3] = UndefinedReader.new
    @@readers_v3[Datatypes::NULL_DATATYPE_V3] = NullReader.new
    @@readers_v3[Datatypes::BOOLEAN_DATATYPE_FALSEV3] = BooleanReader.new false
    @@readers_v3[Datatypes::BOOLEAN_DATATYPE_TRUEV3] = BooleanReader.new true
    @@readers_v3[Datatypes::INTEGER_DATATYPE_V3] = IntegerReader.new
    @@readers_v3[Datatypes::DOUBLE_DATATYPE_V3] = NumberReader.new
    @@readers_v3[Datatypes::UTFSTRING_DATATYPE_V3] = V3StringReader.new
    @@readers_v3[Datatypes::XML_DATATYPE_V3] = V3XmlReader.new
    @@readers_v3[Datatypes::DATE_DATATYPE_V3] = V3DateReader.new
    @@readers_v3[Datatypes::ARRAY_DATATYPE_V3] = V3ArrayReader.new
    @@readers_v3[Datatypes::OBJECT_DATATYPE_V3] = V3ObjectReader.new
    @@readers_v3[Datatypes::LONGXML_DATATYPE_V3] = V3XmlReader.new
    @@readers_v3[Datatypes::BYTEARRAY_DATATYPE_V3] = V3ByteArrayReader.new
  end

  def read_message( input )
    reader = BinaryReader.new input
    version = reader.read_unsigned_short
    total_headers = reader.read_unsigned_short
    headers = Array.new
    
    while total_headers > 0
      name_length = reader.read_unsigned_short
      header_name = reader.read_string( name_length )
      must_understand = reader.read_boolean
	  length = reader.read_integer
      header_value = AmfRequestParser.read_data( reader )
	  header = Header.new( header_name, must_understand, header_value )
      headers.push header
      total_headers = total_headers - 1
    end
    
    total_body_parts = reader.read_unsigned_short
    body_parts = Array.new
    
    while total_body_parts > 0
      service_uri_length = reader.read_unsigned_short
      service_uri = reader.read_string( service_uri_length )
      
      response_uri_length = reader.read_unsigned_short
      response_uri = reader.read_string( response_uri_length )
      
      if Log.info?
        Log.info( "request service uri: " + service_uri.to_s + " response uri: " + response_uri )
      end
      
      length = reader.read_integer
      body_value = AmfRequestParser.read_data( reader )
      body_part = Body.new( service_uri, response_uri, body_value )
      body_parts.push body_part
      
      total_body_parts = total_body_parts - 1
    end
    
    formatter = version == 3 ? AmfV3Formatter.new : AmfV0Formatter.new
    
    if Log.debug?
      Log.debug( "completed parsing version " + version.to_s + " request" )
    end
    
    request = Request.new( version, headers, body_parts, formatter )
  end
  
  def AmfRequestParser.read_data( reader, parse_context=nil, data_type=-1, version=0 )
    if(data_type == -1 || data_type.nil? )
      data_type = reader.read_byte
    end
    
    parse_context = ParseContext.new if(parse_context.nil?)
    version = parse_context.version #note... the version in the method signature is a rat terd
    
    if version == 3
      @@readers_v3[data_type].read( reader, parse_context )
    else
      @@readers_v1[data_type].read( reader, parse_context )
    end
    
  end
end

AmfRequestParser.init_readers