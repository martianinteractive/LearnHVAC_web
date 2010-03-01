# =========================================================================
# log.rb
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
require 'weborb/log/stdout_logger'

class Log

  def self.init
    @@logger = StdOutLogger.new
    @@log_level = Constants::WARN
  end

  def self.debug?
    @@log_level <= Constants::DEBUG 
  end
  
  def self.debug( message )
    @@logger.debug( message )
  end
  
  def self.info?
    @@log_level <= Constants::INFO 
  end
  
  def self.info message
    @@logger.info message
  end

  def self.warn?
    @@log_level <= Constants::WARN 
  end
  
  def self.warn( message )
    @@logger.warn( message )
  end
  
  def self.error?
    @@log_level <= Constants::ERROR 
  end
  
  def self.error message
    @@logger.error message
  end
  
  def self.fatal?
    @@log_level <= Constants::FATAL 
  end
  
  def self.fatal message
    @@logger.fatal message
  end  

  def self.is_logging( log_level )
  
    if log_level == Constants::DEBUG
      @@logger.debug?
    elsif log_level == Constants::INFO
      @@logger.info?
    elsif log_level == Constants::WARN
      @@logger.warn?
    elsif log_level == Constants::ERROR
      @@logger.error?
    elsif log_level == Constants::FATAL
      @@logger.fatal?
    else
      false
    end
  
  end

  def self.log( log_level, message )
    if log_level == Constants::DEBUG
      @@logger.debug message
    elsif log_level == Constants::INFO
      @@logger.info message
    elsif log_level == Constants::WARN
      @@logger.warn message
    elsif log_level == Constants::ERROR
      @@logger.error message
    elsif log_level == Constants::FATAL
      @@logger.fatal message
    end
  end 
				
end

Log.init

