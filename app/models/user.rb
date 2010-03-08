class User < ActiveRecord::Base
  ROLES = { :guest => 0, :student => 1, :instructor => 2, :administrator => 3, :superadmin => 4 }
  validates_presence_of :first_name, :last_name
  acts_as_authentic
  
  
  def role
    ROLES.index(read_attribute(:role_code))
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.deliver_password_reset_instructions(self)  
  end
  
end
