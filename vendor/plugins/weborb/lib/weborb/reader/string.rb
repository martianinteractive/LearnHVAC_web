# =========================================================================
# string.rb
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

class StringType

  def initialize(value)
    @value = value
  end
  
  def default_adapt
    @value
  end 

end

class UTFStringReader
  def read( reader, parse_context )
    string_value = reader.read_utf
	#StringType.new( string_value )
	string_value
  end
end

class LongUTFStringReader
  def read( reader, parse_context )
    length = reader.read_integer
    string_value = reader.read_string( length )
	#StringType.new( string_value )
	string_value
  end
end

class V3StringReader
  def read( reader, parse_context )
    len = reader.read_var_integer

	if( (len & 0x1) == 0 )
	  parse_context.get_string_reference( len >> 1 )
	else  
      str = reader.read_utf( len >> 1 )

	  if( str.length == 0 )
		str
	  else	
		parse_context.add_string_reference( str )
		str
	  end
	end
  end
end