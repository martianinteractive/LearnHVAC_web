# =========================================================================
# install.rb
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

require 'ftools'
require 'fileutils'

controller_file = File.dirname(__FILE__) + '/lib/weborb_controller.rb'
new_file = File.dirname(__FILE__) + '/../../../app/controllers/weborb_controller.rb'
File.move(controller_file, new_file )

config_path = File.dirname(__FILE__) + '/../../../config'
flex_config = config_path + '/WEB-INF/flex'
FileUtils.makedirs flex_config
lib_dir = File.dirname(__FILE__) + "/lib/"
File.move(lib_dir + "services-config.xml", flex_config )
File.move(lib_dir + "remoting-config.xml", flex_config )
File.move(lib_dir + "proxy-config.xml", flex_config )
File.move(lib_dir + "messaging-config.xml", flex_config )
File.move(lib_dir + "data-management-config.xml", flex_config )
File.move(lib_dir + "weborb-config.xml", config_path )

public_path = File.dirname(__FILE__) + '/../../../public'
test_path = public_path + '/examples'
srcview_path = test_path + '/srcview'
FileUtils.makedirs test_path
File.move(lib_dir + "main.html", test_path )
File.move(lib_dir + "main.swf", test_path )
File.move(lib_dir + "AC_OETags.js", test_path )
File.move(lib_dir + "history.htm", test_path )
File.move(lib_dir + "history.js", test_path )
File.move(lib_dir + "history.swf", test_path )
File.move(lib_dir + "playerProductInstall.swf", test_path )

File.move(lib_dir + "example.html", test_path )
File.move(lib_dir + "example.mxml", test_path )
File.move(lib_dir + "example.swf", test_path )

srcview_path = test_path + '/srcview'
FileUtils.makedirs srcview_path
File.move(lib_dir + "srcview/AC_OETags.js", srcview_path )
File.move(lib_dir + "srcview/FlexRemoting.zip", srcview_path )
File.move(lib_dir + "srcview/index.html", srcview_path )
File.move(lib_dir + "srcview/playerProductInstall.swf", srcview_path )
File.move(lib_dir + "srcview/SourceIndex.xml", srcview_path )
File.move(lib_dir + "srcview/SourceStyles.css", srcview_path )
File.move(lib_dir + "srcview/SourceTree.html", srcview_path )
File.move(lib_dir + "srcview/SourceTree.swf", srcview_path )

source_path = srcview_path + '/source'
FileUtils.makedirs source_path
File.move(lib_dir + "srcview/source/main.mxml.html", source_path )

FileUtils.rmdir(lib_dir + 'srcview/source')
FileUtils.rmdir(lib_dir + 'srcview')

app_path = File.dirname(__FILE__) + '/../../../app'
services_path = app_path + '/services'
FileUtils.makedirs services_path
tests_path = services_path + '/weborb/tests'
FileUtils.makedirs tests_path
File.move(lib_dir + "InfoService.rb", services_path )
File.move(lib_dir + "weborb/tests/ComplexTypesTest.rb", tests_path )
File.move(lib_dir + "weborb/tests/FlexRemotingTest.rb", tests_path )
File.move(lib_dir + "weborb/tests/MultipleArgsTest.rb", tests_path )
File.move(lib_dir + "weborb/tests/PrimitiveArrayTest.rb", tests_path )
File.move(lib_dir + "weborb/tests/PrimitiveTest.rb", tests_path )
File.move(lib_dir + "weborb/tests/StringsArrayTest.rb", tests_path )
File.move(lib_dir + "weborb/tests/StringsTest.rb", tests_path )

