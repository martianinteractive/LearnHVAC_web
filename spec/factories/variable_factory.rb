Factory.define :valid_variable, :class  => Variable do |variable|
  variable.name "MXLeakRetDmpr"
  variable.display_name "Lorem Ipsum"
  variable.description "Some description"
  variable.unit_si "%"
  variable.unit_ip "%"
  variable.si_to_ip
  variable.left_label "%0 open"
  variable.right_label "100% open"
  variable.subsection ""
  variable.zone_position "NO_GRADIENT"
  variable.fault_widget_type "SLIDER"
  variable.notes
  variable.component_code "MX"
  variable.io_type "INPUT"
  variable.view_type "public"
  variable.index 22
  variable.lock_version 0
  variable.node_sequence 0
  variable.low_value 0.0
  variable.high_value 100.0
  variable.initial_value 0.0
  variable.is_fault true
  variable.is_percentage true
  variable.disabled true
  variable.fault_is_active false
  variable.scenario {Scenario.first || Factory(:valid_scenario)}
end

Factory.define :valid_scenario_variable, :parent => :valid_variable, :class => ScenarioVariable do |scenario_variable|
end
