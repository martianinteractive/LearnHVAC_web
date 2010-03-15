class Institution < ActiveRecord::Base
  validates :name, :presence => true, :length => { :maximum => 200 }, :uniqueness => true
  has_many :users, :dependent => :destroy
end
