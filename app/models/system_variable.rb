class SystemVariable
  IO_TYPES = ['INPUT', 'OUTPUT', 'PARAMETER']
  COMPONENTS = { "CC" => "Cooling Coil", "HC" => "Heating Coil", "MX" => "Mixing Box", "RM" => "Room", 
                 "BOI" => "Boiler", "CHL" => "Chiller", "CTW" => "Cooling Tower", "DCT" => "Duct", 
                 "DIF" => "Diffuser", "FAN" => "Fan", "FLT" => "Filter", "PLT" => "Plant", "SYS" => "System", "VAV" => "VAV Box" }
  
  validates_associated :master_scenario
  validates_presence_of :name, :display_name, :low_value, :initial_value, :high_value
  validates_numericality_of :low_value, :initial_value, :high_value
  validates :io_type, :inclusion => { :in => IO_TYPES }
  
  belongs_to :master_scenario  
  
  def self.filter(opts)
    opts.each { |k, v| opts[k] = eval(v) if %w(true false).include?(v) }
    where(opts)
  end
  
  def component
    COMPONENTS[read_attribute(:component_code)]
  end
  
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
