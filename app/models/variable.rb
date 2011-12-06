class Variable < ActiveRecord::Base

  IO_TYPES            = %w[INPUT OUTPUT PARAMETER]
  FAULT_WIDGET_TYPES  = %w[Checkbox Slider]
  COMPONENTS          = {
    "CC"  => "Cooling Coil",
    "HC"  => "Heating Coil",
    "MX"  => "Mixing Box",
    "RM"  => "Room",
    "BOI" => "Boiler",
    "CHL" => "Chiller",
    "CTW" => "Cooling Tower",
    "DCT" => "Duct",
    "DIF" => "Diffuser",
    "FAN" => "Fan",
    "FLT" => "Filter",
    "PLT" => "Plant",
    "SYS" => "System",
    "VAV" => "VAV Box"
  }

  # - Validations -
  validates_presence_of :name, :display_name, :low_value, :initial_value, :high_value
  validates_numericality_of :low_value, :initial_value, :high_value
  validates :io_type, :inclusion => { :in => IO_TYPES }

  # - Class Methods -
  def self.filter(opts)
    opts ||= {}
    opts.each { |k, v| opts[k] = eval(v) if %w(true false).include?(v) }
    opts.delete_if {|k, v| v == "Any" }
    where(opts)
  end

  # - Instance Methods -
  def component
    COMPONENTS[read_attribute(:component_code)]
  end

end
