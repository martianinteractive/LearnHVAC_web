require 'weborb/formats/amf_request_parser'

class ObjectProxy
  def read_external( reader, parse_context )
    AmfRequestParser.read_data( reader, parse_context )
  end
end