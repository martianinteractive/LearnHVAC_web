class Membership < ActiveRecord::Base
  belongs_to :member, :class_name => "User", :foreign_key => "member_id"
  belongs_to :scenario
  belongs_to :group
  
  validates_presence_of :member, :scenario
  
  before_create :set_member_role
  
  def recently_created?
    created_at > 20.minutes.ago
  end  
  
  protected
  
  def set_member_role
    self.member_role = member.role.to_s
  end
  
end
