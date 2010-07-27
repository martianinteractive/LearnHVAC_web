class ClassNotificationEmail < ActiveRecord::Base
  belongs_to :group, :foreign_key => "class_id"
  validates_presence_of :body_html, :recipients, :subject
  
  after_create :deliver_notification
  
  
  private
  
  def deliver_notification
    Notifier.join_class_notification(self).deliver
  end
  
end
