class SystemVariable < Variable
  belongs_to :master_scenario, :foreign_key => "scenario_id" 
  
  # before_save :detect_changes
  # before_save :notify_change
  # before_destroy :set_destroy_flag
  # before_destroy :notify_change
  #
  # def skip_notify!
  #   @notify = false
  # end
  # 
  # def notify?
  #   @notify != false
  # end
  # 
  # protected
  # 
  # def detect_changes
  #   return false if @var_changed
  #   @var_changed = self.new_record?
  #   @var_changed = self.changed? unless @var_changed
  #   1
  # end
  # 
  # def set_destroy_flag
  #   @to_destroy = true
  # end
  # 
  # def notify_change
  #   if notify? and (@var_changed or @to_destroy)
  #     self.master_scenario.revise
  #     self.master_scenario.update(false)
  #   end
  # end
  
end
