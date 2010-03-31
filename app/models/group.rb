class Group < ActiveRecord::Base
  belongs_to :instructor, :class_name => "User", :foreign_key => "instructor_id"
  has_many :memberships, :dependent => :destroy
  has_many :students, :through => :memberships
  
  has_many :group_scenarios
  
  validates :name, :presence => true, :length => { :maximum => 200 }, :uniqueness => true
  validates :code, :presence => true, :length => { :maximum => 200 }, :uniqueness => true, :on => :update
  validates :instructor, :presence => true
  
  after_create :set_code
    
  # Define this later using has_many_documents :scenarios, :through => :group_scenarios
  def scenarios
    scenarios_ids = group_scenarios.all.collect { |gs| gs.scenario_id }
    Scenario.criteria.in("_id" => scenarios_ids).to_a
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
  
end
