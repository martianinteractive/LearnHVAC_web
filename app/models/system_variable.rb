class SystemVariable
  include Mongoid::Document
  
  field :display_name
  field :description
  field :io_type
  field :unit_si
  field :si_to_ip
  field :left_label
  field :right_label
  field :subsection
  field :zone_position
  field :fault_widget_type
  field :notes
  field :index,           :type => Integer
  field :lock_version,    :type => Integer,   :default => 0
  field :node_sequence,   :type => Integer,   :default => 0
  field :min_value,       :type => Float,     :default => 0.0
  field :default_value,   :type => Float,     :default => 0.0
  field :max_value,       :type => Float,     :default => 0.0
  field :global_disable,  :type => Boolean,   :default => false
  field :is_fault,        :type => Boolean,   :default => false
  field :is_percentage,   :type => Boolean,   :default => false
end
