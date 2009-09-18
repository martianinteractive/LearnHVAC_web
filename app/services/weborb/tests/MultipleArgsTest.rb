# =========================================================================
# MultipleArgsTest.rb
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

class MultipleArgsTest

  def echoInts( i1, i2, i3, i4 )
    ints = Array.new
    ints.push i1
    ints.push i2
    ints.push i3
    ints.push i4
    ints
  end

  def echoShorts( s1, s2, s3 )
    array = Array.new
    array.push s1
    array.push s2
    array.push s3
    array
  end

  def echoIntLongs( i, l )
    array = Array.new
    array.push i
    array.push l
    array
  end

  def echoIntString( i, s )
	array = Array.new
    array.push i
    array.push s
    array
  end

  def echoIntNullString( i, s )
	array = Array.new
    array.push i
    array.push s
    array
  end

  def echoCharString( c, s )
	array = Array.new
    array.push c
    array.push s
    array
  end

  def echoStringBuilderDouble( sb, d )
	array = Array.new
    array.push sb
    array.push d
    array
  end

  def echoNullStringBuilderDouble( sb, d )
	array = Array.new
    array.push sb
    array.push d
    array
  end

  def echoLotsOfArgs( v, a, h, ct, i, ca, s, dateObj, str )
  #def echoLotsOfArgs( v, a, ct, i, ca, s, dateObj, str )
    array = Array.new
    array.push v
    array.push a
    array.push h
    array.push ct
    array.push i
    array.push ca
    array.push s
    array.push dateObj
    array.push str
    array
  end
  
end