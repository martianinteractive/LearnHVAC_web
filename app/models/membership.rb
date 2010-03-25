class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :student, :class_name => "User", :foreign_key => "student_id"
  
  validates :group, :presence => true
  validates :student, :presence => true
  
  # Passing :scope to the new validates method 
  # "validates :student_id, :uniqueness => true" isn't working. 
  validates_uniqueness_of :student_id, :scope => :group_id 
end
