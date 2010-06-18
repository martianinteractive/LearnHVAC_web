class Group < ActiveRecord::Base
  belongs_to :instructor, :class_name => "User", :foreign_key => "instructor_id"
  has_many :memberships, :dependent => :destroy
  has_many :students, :through => :memberships  
  has_many :group_scenarios, :dependent => :destroy
  
  accepts_nested_attributes_for :group_scenarios, :allow_destroy => true
  
  # Define in module
  attr_writer :scenarios_ids
  
  validates :name, :presence => true, :length => { :maximum => 200 }, :uniqueness => true
  validates :code, :presence => true, :length => { :maximum => 200 }, :uniqueness => true, :on => :update
  validates :instructor, :presence => true
  validate  :scenario_validator
  
  after_create :set_code
  before_save  :handle_scenarios
    
  # Define this later using has_many_documents :scenarios, :through => :group_scenarios
  def scenarios
    Scenario.criteria.in("_id" => scenarios_ids)
  end
  
  def scenarios_ids
    @scenarios_ids.try(:uniq) || group_scenarios.all.collect { |gs| gs.scenario_id }
  end
  
  private
  
  def set_code
    rcode = secure_rand
    while(rcode)
      self.code = rcode
      rcode = Group.find_by_code(rcode) ? secure_rand : nil
    end
    self.save(:validate => false)
  end
  
  def secure_rand
    ActiveSupport::SecureRandom.hex(3)
  end
  
  # move to a module.
  def handle_scenarios
    if @scenarios_ids
      scenarios.each { |scenario| group_scenarios.build(:scenario_id => scenario.id) unless group_scenarios.where(:scenario_id => scenario.id).any?  }
      group_scenarios.each { |gs| gs.destroy unless @scenarios_ids.include?(gs.scenario_id) }
    end
  end
  
  def scenario_validator
    scenarios.each {|scenario| errors.add(:base, "invalid scenario") if scenario.user != self.instructor }
  end
  
end
