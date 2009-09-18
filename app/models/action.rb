class Action < ActiveRecord::Base
  
  # Actions are trackable events by the user, either on the server (when the user is an andministrator or instructor)
  # or on the client. Actions are created by the site admin to describe these events. Actions have
  # names to describe the event, like FlashClientLogin or LoadScenario
  # This model describes the types of events possible...the actual instances of the the events are stored in the ActivityLog model.
  
  has_many :activities
  
end
