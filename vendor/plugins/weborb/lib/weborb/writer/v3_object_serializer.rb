# =========================================================================
# v3_object_serializer.rb
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

require 'weborb/writer/message_writer'
require 'weborb/log'

class V3ObjectSerializer

  def write_object( class_name, object_fields, formatter )
    object_fields.delete( "_orbclassname" )
	formatter.begin_write_named_object( class_name, object_fields.length )
	object_fields.each_key {| key | formatter.write_field_name key.to_s }
		
	object_fields.each do |key, value| 
      
      if Log.debug?
        Log.debug( "serializing property/field : " + key + " value: " + value.to_s )
      end

      field_name = key
      formatter.begin_write_field_value
      
      begin
        MessageWriter.write_object( value, formatter )
      rescue Exception => exception
		puts "exception writing field: " + field_name + " message: " + exception.message + " stack trace:\n" + exception.backtrace.join("\n")
      ensure
        formatter.end_write_field_value
      end
    end	
    
    formatter.end_write_object
  end
end