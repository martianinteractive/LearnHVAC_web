xml.instruct!
xml.scenario do
  xml.id({:type => "Integer"}, @scenario.id)
  xml.name({:type => "String"}, @scenario.name)
  xml.goal({:type => "String"}, @scenario.goal)
  xml.level({:type => "Integer"}, @scenario.level)
  xml.shortDescription({:type => "string"}, @scenario.short_description)
  xml.description({:type => "string"}, @scenario.description)
  xml.valveInfoEnabled({:type => "Boolean"}, @scenario.valve_info_enabled)
  xml.faultsEnabled({:type => "Boolean"}, @scenario.faults_enabled)
  xml.allowRealTimeDateTimeChange({:type => "Boolean"}, @scenario.allow_realtime_datetime_change)
  xml.allowLongTermDateChange({:type => "Boolean"}, @scenario.allow_longterm_date_change)
  xml.inputsEnabled({:type => "Boolean"}, @scenario.inputs_enabled)
  xml.inputsVisible({:type => "Boolean"}, @scenario.inputs_visible)
  xml.faultsVisible({:type => "Boolean"}, @scenario.faults_visible)
  xml.faultsEnabled({:type => "Boolean"}, @scenario.faults_enabled)
  xml.longtermStartDate({:type => "Time"}, @scenario.longterm_start_date)
  xml.longtermStopDate({:type => "Time"},  @scenario.longterm_stop_date)
  xml.realtimeStartDateTime({:type => "Time"},  @scenario.realtime_start_datetime)
    xml.sysVars do
      @scenario.scenario_variables.group_by(&:component_code).each do |component, variables|
        xml.systemNode({:id => component, :name => SystemVariableFields::COMPONENTS[component]}) do
          variables.each do |var|
            xml.sysVar do
              xml.name({:type => "String"}, var.name)
              xml.displayName({:type => "String"}, var.display_name)
              xml.description({:type => "String"}, var.description)
              xml.index({:type => "Integer"}, var.index)
              xml.lowValue({:type => "Float"}, var.low_value)
              xml.highValue({:type => "Float"}, var.high_value)
              xml.initialValue({:type => "Float"}, var.initial_value)
              xml.ioType({:type => "String"}, var.io_type)
              xml.viewType({:type => "String"}, var.view_type)
              xml.unitSI({:type => "String"}, var.unit_si)
              xml.SItoIP({:type => "String"}, var.si_to_ip)
              xml.unitIP({:type => "String"}, var.unit_ip)
              xml.disabled({:type => "Boolean"}, var.disable)
              xml.isFault({:type => "Boolean"}, var.is_fault)
            end
          end
        end
      end
    end
end