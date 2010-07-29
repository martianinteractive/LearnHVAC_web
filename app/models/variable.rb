class Variable < ActiveRecord::Base
  IO_TYPES = ['INPUT', 'OUTPUT', 'PARAMETER']
  COMPONENTS = { "CC" => "Cooling Coil", "HC" => "Heating Coil", "MX" => "Mixing Box", "RM" => "Room", 
                 "BOI" => "Boiler", "CHL" => "Chiller", "CTW" => "Cooling Tower", "DCT" => "Duct", 
                 "DIF" => "Diffuser", "FAN" => "Fan", "FLT" => "Filter", "PLT" => "Plant", "SYS" => "System", "VAV" => "VAV Box" }
  
  validates_presence_of :name, :display_name, :low_value, :initial_value, :high_value, :scenario
  validates_numericality_of :low_value, :initial_value, :high_value
  validates :io_type, :inclusion => { :in => IO_TYPES }
  
  def self.filter(opts)
    opts.each { |k, v| opts[k] = eval(v) if %w(true false).include?(v) }
    where(opts)
  end
  
  def component
    COMPONENTS[read_attribute(:component_code)]
  end
end
