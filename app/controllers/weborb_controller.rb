# =========================================================================
# weborb_controller.rb
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
require 'weborb/formats/parser_factory'
require 'weborb/dispatcher/weborb_dispatcher'
require 'weborb/writer/response_writer'
require 'weborb/config/weborb_config'
require 'weborb/log'
require 'weborb/context'

class WeborbController < ApplicationController

  def index
    input = Array.new
    request.raw_post.each_byte {|byte| input.push byte }
    
    if Log.debug?
      Log.debug( "processing request: " + request.raw_post )
    end
    
    RequestContext.set_context( request, session )
    parser = ParserFactory.getParser
    request_message = parser.read_message input
    success = WebOrbDispatcher.dispatch request_message
    
    formatter = request_message.formatter
    ResponseWriter.write( request_message, formatter );
    bytes = formatter.get_bytes
    formatter.cleanup
    
    binary_string = ""
    bytes.each {|byte| binary_string << byte.chr }
    
    if Log.info?
      Log.info( "returning response, length: " + bytes.length.to_s )
    end

    response.headers["Content-Type"] = "application/x-amf"
    render :text => binary_string
  end
end
