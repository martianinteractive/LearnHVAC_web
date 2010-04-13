class Institution < ActiveRecord::Base
  validates :name, :presence => true, :length => { :maximum => 200 }, :uniqueness => true
  has_many :users, :dependent => :destroy
  has_many :groups, :through => :users, :source => :managed_groups
  
  def scenarios
    Scenario.criteria.in("user_id" => user_ids.collect { |uid| uid.to_s }).to_a
  end
end
