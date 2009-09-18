class Institution < ActiveRecord::Base
  
  has_many :users, :dependent => :destroy
  has_many :scenarios, :dependent => :destroy
  
end
