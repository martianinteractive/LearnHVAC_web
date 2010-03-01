# =========================================================================
# object_handler.rb
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
require 'weborb/reader/anonymous'
require 'weborb/log'

class ObjectHandler

  def handle_invoke( request_message, target_class, function, arguments )
    class_object = ClassUtil.load_class( target_class )
    target_object = class_object.new
    target_method = nil
 
    # look for instance method first, then look for class method, then do something "special"
    # if someone want to try to invoke a "dynamic" AR class method via method_missing
    if target_object.respond_to? function
      target_method = target_object.method function
    elsif class_object.respond_to? function
      target_method = class_object.method function
    elsif ClassUtil.in_class_hierarchy(class_object, "ActiveRecord::Base")
      target_method = class_object.method 'method_missing'
      arguments.unshift(function.intern)
    else
      raise NameError.new('method ' + function + ' not found in ' + target_class)
    end
    
    real_arguments = nil
    result = nil
    
    if Log.info?
      Log.info( "invoking the " + function + " method of type " + target_class )
    end
    
    if arguments.length == 1
      real_arguments = arguments[0]
      result = target_method.call( real_arguments )
    else
      real_arguments = Array.new
      
      for i in 0...arguments.length
        object = arguments[i]
        real_arguments.push object
      end
      
      result = target_method.call( *real_arguments )
    end
      
    result
  end
end