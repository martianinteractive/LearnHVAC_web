# =========================================================================
# boolean.rb
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

require 'weborb/io/binary_reader'
require 'weborb/formats/parse_context'

class BooleanType

  def initialize(value)
    @value = value
  end
  
  def default_adapt
    @value
  end

end

class BooleanReader

  def initialize(initial_value=nil)
    if initial_value.nil?
      @initialized = false
    else
      @initialized = true
      @initial_value = initial_value
    end
  end

  def read( reader, parse_context )
    boolean_value = @initialized ? @initial_value : reader.read_boolean
	#BooleanType.new( boolean_value )
	boolean_value
  end
  
end