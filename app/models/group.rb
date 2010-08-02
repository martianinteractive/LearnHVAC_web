class Group < ActiveRecord::Base
  belongs_to :instructor,         :class_name => "User", :foreign_key => "instructor_id"
  has_many :memberships,          :dependent => :destroy
  has_many :members,              :through => :memberships  
  has_many :group_scenarios,      :dependent => :destroy
  has_many :scenarios,            :through => :group_scenarios
  has_many :notification_emails,  :class_name => "ClassNotificationEmail", :foreign_key => "class_id"

  accepts_nested_attributes_for :group_scenarios, :allow_destroy => true
  
  validates :name, :presence => true, :length => { :maximum => 200 }, :uniqueness => true
  validates :code, :presence => true, :length => { :maximum => 200 }, :uniqueness => true, :on => :update
  validates :instructor, :presence => true
  validate  :scenario_validator
  
  after_create :set_code
  
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
  
  def scenario_validator
    scenarios.each {|scenario| errors.add(:base, "invalid scenario") if scenario.user != self.instructor }
  end
  
end
