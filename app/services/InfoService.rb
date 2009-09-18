require 'weborb/context'
require 'rbconfig'

class InfoService
  def getComputerInfo( requestId )
    computer_info = Hash.new
    request = RequestContext.get_request
    computer_info['serverName'] = request.server_software
    computer_info['requestId'] = requestId
    computer_info['os'] = Config::CONFIG["arch"].to_s
    computer_info['currentTime'] = Time.now
    computer_info
  end
end