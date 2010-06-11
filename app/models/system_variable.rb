class SystemVariable
  include Mongoid::Document
  include Xml
  include SystemVariableFields
  
  embedded_in :master_scenario, :inverse_of => :system_variables

  validates_presence_of :master_scenario
  
  after_update :notify_change
  
  protected
  
  def notify_change
    self.master_scenario.notify_change
  end
  
end
