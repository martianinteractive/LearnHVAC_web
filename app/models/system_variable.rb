class SystemVariable
  include Mongoid::Document
  include SystemVariableFields

  embedded_in :master_scenario, :inverse_of => :system_variables

  validates_presence_of :master_scenario
  before_save :detect_changes
  before_save :notify_change
  before_destroy :set_destroy_flag
  before_destroy :notify_change
    
  def self.filter(opts)
    opts.each { |k, v| opts[k] = eval(v) if %w(true false).include?(v) }
    where(opts)
  end
  
  def skip_notify!
    @notify = false
  end
  
  def notify?
    @notify != false
  end
  
  protected
  
  def detect_changes
    return false if @var_changed
    @var_changed = self.new_record?
    @var_changed = self.changed? unless @var_changed
    1
  end
  
  def set_destroy_flag
    @to_destroy = true
  end
  
  def notify_change
    if notify? and (@var_changed or @to_destroy)
      self.master_scenario.revise
      self.master_scenario.update(false)
    end
  end
  
end
