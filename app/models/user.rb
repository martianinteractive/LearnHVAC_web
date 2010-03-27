require 'search'

class User < ActiveRecord::Base
  include ManyDocuments
  ROLES = { :guest => 0, :student => 1, :instructor => 2, :admin => 3 }
  acts_as_authentic
  
  scope :instructor, where("role_code = #{ROLES[:instructor]}")
  scope :student, where("role_code = #{ROLES[:student]}")
  scope :admin, where("role_code = #{ROLES[:admin]}")
  scope :guest, where("role_code = #{ROLES[:guest]}")
  scope :recently_created, where("created_at < '#{(Time.now + 30.days).to_formatted_s(:db)}'")
  scope :recently_updated, where("updated_at < '#{(Time.now + 30.days).to_formatted_s(:db)}'")
    
  belongs_to :institution
  
  #Maybe we should use simple table inheritance if this type of relationships continue to grow.
  has_many :managed_groups, :class_name => "Group", :foreign_key => "instructor_id"
  has_many :memberships, :foreign_key => "student_id"
  has_many :groups, :through => :memberships
  
  has_many_documents :scenarios
  has_many_documents :master_scenarios
    
  attr_accessor :group_code, :require_group_code
  attr_protected :active, :role_code
  
  validates :first_name, :last_name, :presence => true, :length => { :maximum => 200 }, :format => { :with => /^\w+$/i }
  validate :group_presence,  :on => :create, :if => :require_group_code
  
  def name
    first_name + " " + last_name
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
  
  def active?
    active
  end
  
  def activate!
    self.active = true
    save
  end
  
  def require_group_code!
    @require_group_code = true
  end
  
  private
  
  def group_presence
    self.errors.add(:group_code, "invalid") unless Group.find_by_code(self.group_code)
  end

end
