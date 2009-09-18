# =========================================================================
# response_writer.rb
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

class ResponseWriter

  def ResponseWriter.write( message, formatter )
    formatter.write_message_version( message.version )
    headers = message.response_headers
    formatter.direct_write_short( headers.length )

    # Write out headers
    for i in 0...headers.length
      header = headers[i]
      formatter.direct_write_string( header.header_name )
      formatter.direct_write_boolean( header.must_understand )
      formatter.direct_write_int( -1 )
      MessageWriter.write_object( header.header_value, formatter )
    end
	
	bodies = message.body_parts
	formatter.direct_write_short( bodies.length )
	
	# Write out bodies
	for j in 0...bodies.length
      body = bodies[j]
      formatter.direct_write_string( body.response_uri.nil? ? "null" : body.response_uri )
      formatter.direct_write_string( body.service_uri.nil? ? "null" : body.service_uri )
      formatter.direct_write_int( -1 );
      formatter.begin_write_body_content
      MessageWriter.write_object( body.response_data_object, formatter )
      formatter.end_write_body_content
	end		
			
  end
end