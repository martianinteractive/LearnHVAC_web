class College < ActiveRecord::Base
  
  def self.search(q)
    where("value LIKE '%#{q}%'")
  end
  
end
