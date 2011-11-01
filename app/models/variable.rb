class Variable < ActiveRecord::Base
  IO_TYPES = ['INPUT', 'OUTPUT', 'PARAMETER']
  COMPONENTS = { "CC" => "Cooling Coil", "HC" => "Heating Coil", "MX" => "Mixing Box", "RM" => "Room",
                 "BOI" => "Boiler", "CHL" => "Chiller", "CTW" => "Cooling Tower", "DCT" => "Duct",
                 "DIF" => "Diffuser", "FAN" => "Fan", "FLT" => "Filter", "PLT" => "Plant", "SYS" => "System", "VAV" => "VAV Box" }

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

  def to_csv(options = Hash.new)
    defaults = {:only => Array.new, :except => Array.new}
    defaults.merge! options
    if defaults[:only].any?
      keys = defaults[:only]
    elsif defaults[:except].any?
      keys = attributes.keys - defaults[:except]
    elsif defaults[:only].empty? and defaults[:except].empty?
      keys = attributes.keys
    end
    engine = RUBY_VERSION < "1.9" ? FCSV : CSV
    engine.generate do |csv|
      row = []
      keys.each { |attr| row << self.send(attr) }
      csv << row
    end
  end

end
