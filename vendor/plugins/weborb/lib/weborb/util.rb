# =========================================================================
# util.rb
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

require 'weborb/log'

class NumberUtil

  def NumberUtil.is_integer( number )
    number_string = number.to_s
    decimal_index = number_string.index('.')
    return true if decimal_index.nil?
    decimal_string = number_string.slice( decimal_index + 1, number_string.length - 1  )
    decimal_amount = decimal_string.to_i
    decimal_amount == 0
  end
end

class TimeUtil

  def TimeUtil.time_in_milliseconds( time=Time.now )
    time.to_i * 1000 + ( time.usec/1000 )
  end
  
  def TimeUtil.get_time( date_time, raw_offset, time_offset=0 )
    time_in_milli = date_time - raw_offset + ( time_offset * -1 )
    time_in_sec = time_in_milli/1000
    addtl_milli = time_in_milli % 1000
    time = Time.at( time_in_sec, addtl_milli * 1000 )
    time = time + 3600 if time.isdst
    time
  end
end

class ClassUtil

  def ClassUtil.load_class( class_name, source_path=nil )
    if source_path.nil?
      require_string = class_name.gsub(/\./, "/")
      begin
        if ENV['RAILS_ENV'] == 'development'
          class_loaded = require_or_load(require_string + ".rb")
        else
          class_loaded = require require_string
        end
      rescue Exception => exception
        Log.info("unable to load source file, " + require_string + ", hopefully Rails has already loaded it.")
      end
      end_index = require_string.rindex '/'
      target_class = end_index.nil? ? require_string : require_string.slice( end_index + 1, require_string.length - 1  )
      class_object = Object.const_get target_class
    else
      require_string = source_path.gsub(/\./, "/")
      begin
        class_loaded = require require_string
      rescue Exception => exception
        Log.info("unable to load source file, " + require_string + ", hopefully Rails has already loaded it.")
      end
      class_object = Object.const_get class_name
    end
  end
  
  def ClassUtil.in_class_hierarchy( subclass, parent_name )
    parent = subclass.superclass
    
    while !parent.nil?
      return true if parent.name == parent_name
      parent = parent.superclass
    end
    
    return false
  end
end

class Module
  alias_method :original_attr, :attr

  def attr( aSymbol, writable=false ) 
    @attributes = Array.new if @attributes.nil?
    @attributes.push aSymbol
    original_attr( aSymbol, writable ) 
  end
  
  def attr_accessor( *symbols_array ) 
    symbols_array.each { |symbol| attr(symbol, true)}
  end
  
  def attr_reader( *symbols_array ) 
    symbols_array.each { |symbol| attr(symbol)}
  end
  
  def get_attributes
    @attributes = Array.new if @attributes.nil?
    parent = self.superclass
    
    while( parent != Object )
      parent_attributes = parent.get_attributes
      @attributes.push( *parent_attributes ) unless parent_attributes.nil?
      parent = parent.superclass
    end
    
    @attributes
  end
  
  def set_full_name( fullname )
    @full_name = fullname
  end
  
  def get_full_name
    @full_name
  end
  
end