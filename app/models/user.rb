class User < ActiveRecord::Base
  ROLES = { :guest => 0, :student => 1, :instructor => 2, :admin => 3 }
  validates :first_name, :last_name, :presence => true, :length => { :maximum => 200 }, :format => { :with => /^\w+$/i }
  acts_as_authentic
  
  scope :instructor, where("role_code = #{ROLES[:instructor]}")
  scope :student, where("role_code = #{ROLES[:student]}")
  scope :admin, where("role_code = #{ROLES[:admin]}")
  scope :recently_created, where("created_at < '#{(Time.now + 30.days).to_formatted_s(:db)}'")
  scope :recently_updated, where("updated_at < '#{(Time.now + 30.days).to_formatted_s(:db)}'")
  
  def name
    first_name + " " + last_name
  end
  
  belongs_to :institution
  attr_protected :active
  
  after_create :copy_system_variables, :if => Proc.new { |u| u.has_role?(:instructor) }
  
  def role
    ROLES.index(read_attribute(:role_code))
  end
  
  def has_role?(_role)
    _role.to_sym == role
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
  
  def system_variables
    SystemVariable.all(:conditions => { :user_id => self.id.to_s }).to_a
  end
  
  private
  
  # At the moment only is called on create,
  # we need to define a flow when updating a role.
  def copy_system_variables
    GlobalSystemVariable.all.each do |gsv|
      atts = gsv.attributes
      atts.delete("_id")
      isv = SystemVariable.new(atts)
      isv.user = self
      isv.save
    end
  end
end
