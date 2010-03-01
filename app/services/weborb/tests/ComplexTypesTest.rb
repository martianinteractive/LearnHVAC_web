# =========================================================================
# ComplexTypesTest.rb
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

class ComplexTypesTest

  def echoComplexType( complex_type )
    complex_type
  end

  def echoNullComplexType( null_complex_type )
    null_complex_type
  end

  def echoSubclass( subclass )
    subclass
  end

  def getEmployee( name )
    emp = Employee.new
    emp.employeeName = name
    emp
  end

  def setEmployee( employee )
    employee.employeeName == "Joe Orbman"
  end
  
end

class Employee
  attr_accessor( :employeeName, :employeeId, :employeeTitle, :phoneNumber )
end