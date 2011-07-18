class ClassNotificationEmail < ActiveRecord::Base
  belongs_to :group, :foreign_key => "class_id"
  
  validates_presence_of :body, :recipients, :subject
  validates_associated :group
  validate :recipients_validator, :if => Proc.new { |email| email.recipients.present? }
  
  after_create :deliver_notification
  
  def from
    "#{group.creator.name} <#{Site.config['from']}>"
  end
  
  def subject
    read_attribute(:subject) || "LearnHVAC class invitation"
  end
  
  private
  
  def recipients_validator
    self.recipients.each { |r| errors.add(:recipients, "invalid format") unless r =~ Authlogic::Regex.email }
  end
  
  def deliver_notification
    self.recipients.each { |recipient|
      Notifier.join_class_notification(self,recipient).deliver
    }
  end

end
