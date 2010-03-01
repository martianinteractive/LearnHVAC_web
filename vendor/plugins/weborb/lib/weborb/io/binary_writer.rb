# =========================================================================
# binary_writer.rb
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

class BinaryWriter
  attr_reader :bytes
  
  def initialize
    @bytes = Array.new
  end
  
  def write_short( short )
    write_byte( ((short >> 8) & 0xFF) )
    write_byte( ((short >> 0) & 0xFF) )
  end
  
  def write_int( integer )
    write_byte( ((integer >> 24) & 0xFF) )
    write_byte( ((integer >> 16) & 0xFF) )
    write_byte( ((integer >> 8) & 0xFF) )
    write_byte( ((integer >> 0) & 0xFF) )
  end
  
  def write_double( number )
    binary_string = [number].pack('G')
    write_string( binary_string )
  end
  
  def write_string( string )
    string.each_byte {|byte| write_byte(byte)}
  end
  
  def write_byte( byte )
    @bytes.push byte
  end
  
  def write_utf( content, extendedutf=false, prepend_byte=false )
	strLength = content.length
	charr = Array.new
	content.each_byte {|byte| charr.push byte }
	c = 0
	count = 0
	
	if prepend_byte
	  bytearr = Array.new( strLength + ( strLength <= 65535 ? 3 : 5 ) )
	  bytearr[ count ] = strLength <= 65535 ? 2 : 12
      count += 1
	else
	  bytearr = Array.new( extendedutf ? strLength : strLength + 2 )
	end

	if( extendedutf )
	  write_var_int( (strLength << 1 | 0x1) )
	else
	
	  if( strLength > 65535 )
        bytearr[ count ] = ( strLength >> 24 & 0xFF )
	    count += 1
	    bytearr[ count ] = ( strLength >> 16 & 0xFF )
  	    count += 1
  	  end
	
	  bytearr[ count ] = ( strLength >> 8 & 0xFF )
	  count += 1
	  bytearr[ count ] = ( strLength >> 0 & 0xFF )
  	  count += 1
    end

	for i in 0...strLength
      c = charr[ i ]
      bytearr[ count ] = c
	  count += 1
	end

	bytearr.each{ |byte| write_byte(byte) }
  end
  
  def write_var_int( v )
	if( v < 128 )
	  write_byte( v )
	elsif( v < 16384 )
	  write_byte( (v >> 7 & 0x7F | 0x80) )
	  write_byte( (v & 0x7F) )
	elsif( v < 2097152 )
	  write_byte( (v >> 14 & 0x7F | 0x80) )
	  write_byte( (v >> 7 & 0x7F | 0x80) )
	  write_byte( (v & 0x7F) );
	elsif( v < 1073741824 )
	  write_byte( (v >> 22 & 0x7F | 0x80) )
	  write_byte( (v >> 15 & 0x7F | 0x80) )
	  write_byte( (v >> 8 & 0x7F | 0x80) )
	  write_byte( (v & 0xFF) )
    end
  end
end