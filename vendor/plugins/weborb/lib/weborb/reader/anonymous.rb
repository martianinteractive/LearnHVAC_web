# =========================================================================
# anonymous.rb
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
require 'weborb/formats/parse_context'
require 'weborb/formats/amf_request_parser'

class AnonymousObject < Hash
  attr_accessor :full_name, :internal_id
  
  def properties
    self
  end  
   
  def default_adapt
    self
  end
  
  def method_missing(method_symbol)
    #NOTE... one problem with this approach is if a "property" is nil...
    #it won't show up in the properties hash, but it does exist on the real object
    method_name = method_symbol.id2name
    
    if self.has_key?( method_name )
      self[method_name]
    else
      super(method_symbol)
    end
  end

end

class AnonymousObjectReader

  def read( reader, parse_context )
	anonymous_object = AnonymousObject.new()
	parse_context.add_reference( anonymous_object )
  
    while( true )
      prop_name = reader.read_utf
	  obj = nil
      data_type = reader.read_byte
      
      if( data_type == Datatypes::REMOTEREFERENCE_DATATYPE_V1 && prop_name != "nc" )
		obj = 0 # must be an instance of Flash's Number
	  else
		obj = AmfRequestParser.read_data( reader, parse_context, data_type )
	  end

	  if obj.nil? 
	     break
	  end

      #puts "storing anonymous property, name: " + prop_name + " object: " + obj.to_s
      anonymous_object.store( prop_name, obj )
    end
  
    if( anonymous_object.length == 1 && anonymous_object.has_key?( "nc" ) )
      anonymous_object[ "nc" ]
    else
      anonymous_object
    end
  end
  
end

class BoundPropertyBagReader
  
  def read( reader, parse_context )
	anonymous_object = AnonymousObject.new()
	parse_context.add_reference( anonymous_object )
  
    while( true )
      prop_name = reader.read_utf
	  obj = AmfRequestParser.read_data( reader, parse_context )
		
      if obj.nil? 
	     break
	  end

	  anonymous_object.store( prop_name, obj )
    end

	anonymous_object
  end
end