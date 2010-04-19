class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :student, :class_name => "User", :foreign_key => "student_id"
  
  validates :group, :presence => true
  validates :student, :presence => true
  validates_uniqueness_of :student_id, :scope => :group_id 
  
  def recently_created?
    created_at > 20.minutes.ago
  end
end
