class User < ActiveRecord::Base
  ROLES = { :guest => 0, :student => 1, :instructor => 2, :administrator => 3, :superadmin => 4 }
  validates :first_name, :last_name, :presence => true, :length => { :maximum => 200 }, :format => { :with => /^\w+$/i }
  acts_as_authentic
  
  belongs_to :institution
  attr_protected :active
  
  after_create :copy_system_variables, :if => Proc.new { |u| u.is_a?(:instructor) }
  
  def role
    ROLES.index(read_attribute(:role_code))
  end
  
  def is_a?(_role)
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
  
  private
  
  def copy_system_variables
    GlobalSystemVariable.all.each do |gsv|
      atts = gsv.attributes
      atts.delete("_id")
      isv = InstructorSystemVariable.new(atts)
      isv.user = self
      isv.save
    end
  end
end
