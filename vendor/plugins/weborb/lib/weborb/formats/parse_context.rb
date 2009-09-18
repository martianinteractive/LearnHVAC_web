# =========================================================================
# parse_context.rb
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

class ParseContext
  attr_accessor :version
  
  def initialize(version=0)
    @version = version
    @references = Array.new
    @stringReferences = Array.new
    @class_infos = Array.new
  end

  def add_reference( adapting_type )
    @references.push adapting_type
  end
  
  def get_reference( pointer )
    @references[ pointer ]
  end
  
  def add_string_reference( refStr )
	@stringReferences.push refStr
  end

  def get_string_reference( index )
    @stringReferences[ index ]
  end
  
  def add_class_info_reference( object_val )
	@class_infos.push( object_val )
  end
  
  def get_class_info_reference( index )
	@class_infos[ index ]
  end
end