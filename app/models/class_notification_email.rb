class ClassNotificationEmail < ActiveRecord::Base
  belongs_to :class, :class_name => "Group", :foreign_key => "class_id"
end
