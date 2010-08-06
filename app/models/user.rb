require 'search'

class User < ActiveRecord::Base
  ROLES = { :guest => 0, :student => 1, :instructor => 2, :manager => 3, :admin => 4 }
  acts_as_authentic
  
  belongs_to :institution
  has_many :created_scenarios, :class_name => "Scenario"
  has_many :master_scenarios
  has_many :managed_groups, :class_name => "Group", :foreign_key => "creator_id", :dependent => :destroy
  has_many :group_memberships, :foreign_key => "member_id"
  has_many :groups, :through => :group_memberships, :uniq => true
  
  has_many :individual_memberships, :foreign_key => "member_id"
  # let's name 'em public scenarios for now.
  has_many :individual_scenarios, :through => :individual_memberships, :source => :scenario
  
  attr_accessor :group_code, :require_group_code
  attr_protected :active, :role_code, :enabled
  
  validates :first_name, :last_name, :role_code, :city, :state, :country, :presence => true, :length => { :maximum => 200 }, :format => { :with => /^[A-Za-z0-9\s]+$/ }
  validates_length_of :phone, :in => 7..32, :allow_blank => true
  validate :group_presence,  :on => :create, :if => :require_group_code
  
  # Dynamically creates scopes for each role.
  ROLES.keys.each { |role| scope role.to_s.singularize, where("role_code = #{ROLES[role]}") }
  scope :admin_instructor, where("role_code = #{User::ROLES[:admin]} OR role_code = #{User::ROLES[:instructor]}")
  scope :non_admin, where(["role_code != ?", User::ROLES[:admin]])
  scope :recently_created, where(["created_at > ?", 30.days.ago])
  scope :recently_updated, where(["updated_at > ?", 30.days.ago])
  scope :recent, :limit => 10, :order => "created_at DESC"
  
  before_save :set_institution, :on => :create, :if => Proc.new { |user| user.has_role?(:student) }
  
  def name
    first_name.capitalize + " " + last_name.capitalize
  end
  
  def role
    ROLES.index(read_attribute(:role_code))
  end
  
  def has_role?(_role)
    _role.to_sym == role
  end
  
  def institution_name
    self.institution.name if self.institution
  end
  
  def institution_name=(name)
    self.institution = Institution.find_or_create_by_name(name)
  end
  
  def unread_scenario_alerts
    alerts = []
    scenarios.with_unread_alerts.order_by("created_at DESC").each do |scenario|
      alerts << scenario.scenario_alerts.unread
    end
    alerts.flatten
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.password_reset_instructions(self).deliver
  end
  
  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.activation_instructions(self).deliver
  end
  
  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.activation_confirmation(self).deliver
  end
    
  def activate!
    self.active = true
    save
  end
  
  def require_group_code!
    @require_group_code = true
  end
  
  def _group
    Group.find_by_code(group_code)
  end
  
  def all_scenarios
    [created_scenarios, individual_scenarios, groups.collect(&:scenarios)].flatten.uniq
  end
  
  def has_access_to?(scenario)
    return true if user_scenarios.exists?(:scenario_id => scenario.id)
    return true if groups.any? && groups.collect(&:scenarios).include?(scenario)
    false
  end
  
  private
  
  def group_presence
    self.errors.add(:group_code, "invalid") unless Group.find_by_code(self.group_code)
  end
  
  def set_institution
    # Only used from students/sign_up
    if self.group_code
      group = Group.find_by_code(self.group_code)
      self.institution = group.creator.institution
    end
  end

end
