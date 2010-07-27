class ClassNotificationEmail < ActiveRecord::Base
  belongs_to :group, :foreign_key => "class_id"
end
