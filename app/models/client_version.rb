class ClientVersion < ActiveRecord::Base
  validates_presence_of :version, :url, :release_date
end
