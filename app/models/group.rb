class Group < ActiveRecord::Base
  belongs_to :instructor, :class_name => "User", :foreign_key => "instructor_id"
  has_many :memberships
  has_many :students, :through => :memberships
end
