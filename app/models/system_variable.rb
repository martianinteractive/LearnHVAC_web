class SystemVariable
  include Mongoid::Document
  TYPES = {:input => 0 , :output => 1, :parameter => 2}
  
  field :name
  field :display_name
  field :description
  field :unit_si
  field :unit_ip
  field :si_to_ip
  field :left_label
  field :right_label
  field :subsection
  field :zone_position
  field :fault_widget_type
  field :notes
  field :type_code,       :type => Integer
  field :index,           :type => Integer
  field :lock_version,    :type => Integer,   :default => 0
  field :node_sequence,   :type => Integer,   :default => 0
  field :min_value,       :type => Float,     :default => 0.0
  field :default_value,   :type => Float,     :default => 0.0
  field :max_value,       :type => Float,     :default => 0.0
  field :global_disable,  :type => Boolean,   :default => false
  field :is_fault,        :type => Boolean,   :default => false
  field :is_percentage,   :type => Boolean,   :default => false
  
  def io_type
    TYPES.index(read_attribute(:type_code))
  end
  
end
