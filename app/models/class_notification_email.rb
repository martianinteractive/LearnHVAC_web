class ClassNotificationEmail < ActiveRecord::Base
  belongs_to :group, :foreign_key => "class_id"
  validates_presence_of :body, :recipients, :subject
  validates_associated :group
  
  after_create :deliver_notification
  
  def from
    "#{group.instructor.name} <#{Site.config['from']}>"
  end
  
  def subject
    read_attribute(:subject) || "LearnHVAC class invitation"
  end
  
  private
  
  def deliver_notification
    Notifier.join_class_notification(self).deliver
  end
  
end
