# =========================================================================
# named.rb
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
require 'weborb/mapping'
require 'weborb/io/binary_reader'
require 'weborb/formats/parse_context'
require 'weborb/reader/anonymous'
require 'weborb/log'

class NamedObject
  attr_reader :object_name, :anonymous_object, :typed_object

  def initialize( object_name, typed_object )
    @object_name = object_name
    @anonymous_object = typed_object
  end
  
  def default_adapt
    server_class_info = Mapping.get_server_class_info( @object_name )
    
    if server_class_info.nil?
      self
    else
      return @typed_object unless @typed_object.nil?
      class_name = server_class_info.class_name
      source_path = server_class_info.source
      class_object = ClassUtil.load_class( class_name, source_path )
      
      if ClassUtil.in_class_hierarchy(class_object, "ActiveRecord::Base")
        if class_object.exists?(@anonymous_object[class_object.primary_key])
          target_object = class_object.find(@anonymous_object[class_object.primary_key])
          target_object.attributes=(@anonymous_object)
        else
          target_object = class_object.new(@anonymous_object)
        end
      else
        target_object = class_object.new
      
        @anonymous_object.properties.each_pair do |key, value|
          method_name = key.to_s + "="
        
          if target_object.respond_to? method_name
            target_method = target_object.method method_name
            target_method.call value
          else
            if Log.debug?
              Log.debug( "object of type: " + class_name + " does not respond to method: " + method_name )
            end 
          end
        end
      end
      
      @typed_object = target_object
      @typed_object
    end
    
  end
  
  def method_missing(method_symbol)
    method_name = method_symbol.id2name
    properties = @anonymous_object.properties
    
    if properties.has_key?( method_name )
      properties[method_name]
    else
      super(method_symbol)
    end
  end
  
end

class NamedObjectReader

  def initialize
    @object_reader = AnonymousObjectReader.new
  end
  
  def read( reader, parse_context )
    object_name = reader.read_utf   
    typed_object = @object_reader.read( reader, parse_context ) 
	NamedObject.new( object_name, typed_object ).default_adapt
  end
  
end