class Institution < ActiveRecord::Base

  CATEGORIES = { "community college" => 0, "goverment" => 1, "labor union" => 2, "university" => 3 }

  validates :name, :presence => true, :length => { :maximum => 200 }, :uniqueness => true

  has_many :users, :dependent => :destroy
  has_many :groups, :through => :users, :source => :managed_groups
  has_many :scenarios, :through => :users, :source => :created_scenarios

  scope :recent, :limit => 10, :order => "created_at DESC"
  scope :with_public_scenarios, lambda {
    scenarios = Scenario.arel_table
    joins(:scenarios).where(scenarios[:public].eq(true))
  }

  def category
    CATEGORIES.index(read_attribute(:category_code))
  end

end
