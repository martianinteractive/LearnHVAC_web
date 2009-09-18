# =========================================================================
# array.rb
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

require 'weborb/io/binary_reader'
require 'weborb/formats/parse_context'
require 'weborb/formats/amf_request_parser'

#class ArrayType
#
#  def initialize(array)
#    @array = array
#  end
#  
#  def default_adapt
#    @array
#  end 
#
#end

class ArrayReader
  def read( reader, parse_context )
    length = reader.read_integer
    #puts "reading an array of length: " + length.to_s
	array = Array.new
	#array_type = ArrayType.new( array )
	#parse_context.add_reference( array_type )
	parse_context.add_reference( array )

    while length > 0
      data = AmfRequestParser.read_data( reader, parse_context )
      array.push data
      length = length - 1
    end

    #array_type
    array
  end
end

class V3ArrayReader
  
  def initialize 
    @string_reader = V3StringReader.new
  end

  def read( reader, parse_context )
    ref_id = reader.read_var_integer

	if( (ref_id & 0x1) == 0 )
	  parse_context.get_reference( ref_id >> 1 )
	else 
	  array_size = ref_id >> 1
	  adapting_type = nil
	  container = nil
		
	  while( true )
	    str = @string_reader.read( reader, parse_context )
        break if( str.nil? || str.length == 0 )

        if container.nil?
		  #container = Hash.new
		  #adapting_type = AnonymousObject.new( container )
		  adapting_type = AnonymousObject.new()
		  container = adapting_type
		  parse_context.add_reference( adapting_type )
		end

		obj = AmfRequestParser.read_data( reader, parse_context )
		container[ str ] = obj
      end
      
      if adapting_type.nil?
		container = Array.new array_size
		#adapting_type = ArrayType.new( container )
		adapting_type = container
		parse_context.add_reference( adapting_type )

		for i in 0...array_size
		  container[ i ] = AmfRequestParser.read_data( reader, parse_context )
		end
	  else
		for i in 0...array_size
		  obj = AmfRequestParser.read_data( reader, parse_context )
		  container[ i.to_s ] = obj
		end
      end

      #adapting_type.refresh if adapting_type.respond_to? :refresh
	  adapting_type		
	end
  end
end