class Group < ActiveRecord::Base
  belongs_to :creator,            :class_name => "User", :foreign_key => "creator_id"
  has_many :memberships,          :class_name => "GroupMembership", :dependent => :destroy
  has_many :members,              :through => :memberships, :uniq => true
  has_many :group_scenarios,      :dependent => :destroy
  has_many :scenarios,            :through => :group_scenarios
  has_many :notification_emails,  :class_name => "ClassNotificationEmail", :foreign_key => "class_id"

  accepts_nested_attributes_for :group_scenarios, :allow_destroy => true
  
  validates :code, :presence => true, :length => { :maximum => 200 }, :uniqueness => true
  validates :name, :length => {:maximum => 200 }
  validates_uniqueness_of :name, :scope => :creator_id
  validates_presence_of :name, :creator, :scenarios
  
  before_validation(:on => :create) do
    rcode = secure_rand
    while(rcode)
      self.code = rcode
      rcode = Group.find_by_code(rcode) ? secure_rand : false
    end
  end
  
  def create_memberships(user)
    scenarios.each { |s| memberships.create(:member => user, :scenario => s) }
    memberships.where(:member_id => user.id)
  end
  
  private
  
  def secure_rand
    ActiveSupport::SecureRandom.hex(3)
  end
    
end
