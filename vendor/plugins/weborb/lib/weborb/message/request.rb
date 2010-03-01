# =========================================================================
# request.rb
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

class Header
	attr_reader :header_name, :must_understand, :header_value
	
	def initialize( header_name, must_understand, header_value )
		@header_name = header_name
		@must_understand = must_understand
		@header_value = header_value
	end
end

class Body
  attr_accessor :service_uri, :response_uri, :data_object, :response_data_object
  
  def initialize( service_uri, response_uri, data_object )
	@service_uri = service_uri
	@response_uri = response_uri
	@data_object = data_object
	
#	if( data_object.class.name == "ArrayType" ) #need to do this the "Ruby Way"
#	  @data_object = data_object.default_adapt
#	else
#	  @data_object = data_object
#	end
  end
end

class Request
	attr_accessor :version, :body_parts, :formatter, :response_headers
	@@instancesCreated = 0
	
	def initialize( version, headers, body_parts, formatter )
		@@instancesCreated = @@instancesCreated + 1
		@version = version
		@headers = headers
		@body_parts = body_parts
		@formatter = formatter
		@response_headers = Array.new #this is empty in .Net impl
	end
	
	def get_initial_request_uri
	  @body_parts[0].service_uri
	end
	
	def get_initial_request_body
	  @body_parts[0].data_object
	end
end