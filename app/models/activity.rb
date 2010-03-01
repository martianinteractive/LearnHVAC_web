class Activity < ActiveRecord::Base
  
  # This class tracks user events. Events are described by the Action model.
  # This model has two generic fields to track the details of an action: value_id and value_string
  # These values can be used according to what needs to be tracked for an action...if the action is 
  # LoadScenario, the value_id field can be used to contain the scenario ID
  # TODO: need a way to formalize how the fields are used for different actions...or perhaps a better event architecture with subclassing?
  
  belongs_to :action
	belongs_to :user
  
end
