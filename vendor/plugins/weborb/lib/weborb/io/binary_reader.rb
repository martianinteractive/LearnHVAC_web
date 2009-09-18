# =========================================================================
# binary_reader.rb
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

class BinaryReader

 def initialize( bytes )
   @bytes = bytes
   @index = 0
 end

 def read_unsigned_short
   byte1 = read_byte
   byte2 = read_byte
   (byte1 << 8) + (byte2 << 0)
 end

 def read_integer
   byte1 = read_byte
   byte2 = read_byte
   byte3 = read_byte
   byte4 = read_byte
      
   if byte4.nil?
     byte4 = 0
   end
   
   ((byte1 << 24) + (byte2 << 16) + (byte3 << 8) + (byte4 << 0))
 end

 def read_double
   bytes = Array.new(8);
   result = ""
   
   bytes.each do |byte|
    byte = read_byte
    byte = 0 if byte.nil?
    result << byte
   end
   
   double = result.unpack('G')
   double[0]
 end

 def read_boolean
   byte1 = read_byte
   byte1 != 0
 end

 def read_utf( len=nil )
   if len.nil?
     length = read_unsigned_short
     read_string( length )
   else
     string = ""
     bytes = read_bytes( len )
     i = 0; 
			
     while( i < len )
	   c = bytes[ i ] & 0xFF
	   code = c >> 4

	   if( code >= 0 && code <= 7 )
	     i += 1
		 string << c.chr
	   elsif( code == 12 || code == 13 )
		 i += 2
		 char2 = bytes[ i - 1 ]
	     string << (c.chr + char2.chr)
	   elsif( code == 14 )
		 i += 3
 		 char2 = bytes[ i - 2 ]
		 char3 = bytes[ i - 1 ]
		 string << (c.chr + char2.chr + char3.chr)
	   else
	     #  raise error "invalid UTF data"
       end
     end
     
     string
   end
 end
 

 def read_string( length )
   string = ""

   while( length > 0 )
     byte1 = read_byte
     length -= 1
     string << byte1.chr
   end

   string
 end
 
 def read_bytes( length )
   bytes = Array.new

   while( length > 0 )
     byte = read_byte
     bytes.push byte
     length -= 1
   end

   bytes
 end

 def read_byte
   byte = @bytes[@index]
   @index += 1
   byte
 end
 
 def read_var_integer
   #NOTE: this method does not deal properly with negative integers!!
   num = read_byte() 
   return 0 if num.nil?
   num = num & 0xFF
   return num if( num < 128 )

   val = (num & 0x7F) << 7
   num = next_byte()
   return (val | num) if( num < 128 )

   val = (val | num & 0x7F) << 7
   num = next_byte()
   return (val | num) if( num < 128 )

   val = (val | num & 0x7F) << 8
   num = next_byte()
   val | num
 end
 
 private
 def next_byte
   num = read_byte()
   num = 0 if num.nil?
   num = num & 0xFF
   num
 end
end