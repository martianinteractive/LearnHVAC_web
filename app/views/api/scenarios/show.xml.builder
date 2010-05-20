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
  xml.longtermStartDate({:type => "Time"}, @scenario.longterm_start_date)
  xml.longtermStopDate({:type => "Time"},  @scenario.longterm_stop_date)
  xml.realtimeStartDateTime({:type => "Time"},  @scenario.realtime_start_datetime)
    xml.sysVars do
      @scenario.scenario_variables.group_by(&:component_code).each do |component, variables|
        xml.systemNode
          xml.id(component)
          xml.name(SystemVariableFields::COMPONENTS[component])
          variables.each do |variable|
            xml.sysVar do
              xml.name(variable.name)
              xml.displayName(var.display_name)
              xml.description(var.description)
              xml.index(var.index)
              xml.lowValue(var.low_value)
              xml.highValue(var.high_value)
              xml.initialValue(var.initial_value)
              xml.ioType(var.io_type)
              xml.viewType(var.view_type)
              xml.unitSI(var.unit_si)
              xml.SItoIP(var.si_to_ip)
              xml.unitIP(var.unit_ip)
              xml.disable(var.disable)
              xml.isFault(var.is_fault)
            end
          end
      end
    end
end