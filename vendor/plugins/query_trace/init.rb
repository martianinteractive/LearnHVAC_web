require 'query_trace'

class ::ActiveRecord::LogSubscriber
  include QueryTrace
end
