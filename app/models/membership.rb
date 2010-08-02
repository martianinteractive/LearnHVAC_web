class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :member, :class_name => "User", :foreign_key => "member_id"
  
  validates_presence_of :group, :member
  validates_uniqueness_of :member_id, :scope => :group_id 
  
  def recently_created?
    created_at > 20.minutes.ago
  end
end
