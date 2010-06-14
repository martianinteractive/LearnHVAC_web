class SystemVariable
  include Mongoid::Document
  include Xml
  include SystemVariableFields

  embedded_in :master_scenario, :inverse_of => :system_variables

  validates_presence_of :master_scenario
  # before_save :detect_changes
  # after_save :notify_change
  
  protected
  
  # def detect_changes
  #   @var_changed = self.new_record?
  #   @var_changed = self.changed? unless @var_changed
  #   1
  # end
  # 
  # def notify_change
  #   #triggers versions.
  #   self.master_scenario.save if @var_changed
  # end
  
end
