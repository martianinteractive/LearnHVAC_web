class Institution < ActiveRecord::Base
  CATEGORIES = { "community college" => 0, "goverment" => 1, "labor union" => 2, "university" => 3 }
  validates :name, :presence => true, :length => { :maximum => 200 }, :uniqueness => true
  has_many :users, :dependent => :destroy
  has_many :groups, :through => :users, :source => :managed_groups
  
  def category
    CATEGORIES.index(read_attribute(:category_code))
  end
  
  def scenarios
    Scenario.criteria.in("user_id" => user_ids.collect { |uid| uid.to_s }).to_a
  end
end
