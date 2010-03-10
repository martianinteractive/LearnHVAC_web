class Institution
  include Mongoid::Document
  field :name
  field :description
  
  validates :name, :presence => true, :length => { :maximum => 200 }, :uniqueness => true
  has_many_related :users, :dependent => :destroy
end
