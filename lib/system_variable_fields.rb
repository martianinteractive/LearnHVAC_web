module SystemVariableFields
  TYPES = {:input => 0 , :output => 1, :parameter => 2}
  
  def self.included(parent)
    parent.field :name
    parent.field :display_name
    parent.field :description
    parent.field :unit_si
    parent.field :unit_ip
    parent.field :si_to_ip
    parent.field :left_label
    parent.field :right_label
    parent.field :subsection
    parent.field :zone_position
    parent.field :fault_widget_type
    parent.field :notes
    parent.field :type_code,       :type => Integer
    parent.field :index,           :type => Integer
    parent.field :lock_version,    :type => Integer,   :default => 0
    parent.field :node_sequence,   :type => Integer,   :default => 0
    parent.field :min_value,       :type => Float,     :default => 0.0
    parent.field :default_value,   :type => Float,     :default => 0.0
    parent.field :max_value,       :type => Float,     :default => 0.0
    parent.field :global_disable,  :type => Boolean,   :default => false
    parent.field :is_fault,        :type => Boolean,   :default => false
    parent.field :is_percentage,   :type => Boolean,   :default => false
    
    parent.send :include, SysVarMethods
  end

  module SysVarMethods
    
    def io_type
      TYPES.index(read_attribute(:type_code))
    end
    
  end

end