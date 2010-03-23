class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :student, :class_name => "User", :foreign_key => "student_id"
  
  validate :group_id, :presence => true
  validate :student_id, :presence => true
  validate :group_id, :uniqueness => true, :scope => :student_id
end
