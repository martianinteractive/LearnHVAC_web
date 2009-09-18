# =========================================================================
# DataService.rb
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

class DataService
  def create( model_name, model_info )
    model_class = Object.const_get model_name
    model = model_class.new(model_info)
    save_success = model.save
    model
  end
  
  def update( model_name, model_info )
    model_class = Object.const_get model_name
    update_method = model_class.method :update
    model = update_method.call(model_info['id'], model_info)
    model
  end
  
  def remove( model_name, model_id )
    model_class = Object.const_get model_name
    delete_method = model_class.method :delete
    delete_success = delete_method.call(model_id)
    delete_success
  end
  
  def list( model_name )
    model_class = Object.const_get model_name
    find_method = model_class.method :find
    find_method.call(:all)
  end
end