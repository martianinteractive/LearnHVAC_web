xml.instruct!
xml.scenario do
  xml.id({:type => "Integer"}, @scenario.id)
  xml.name({:type => "String"}, @scenario.name)
  xml.studentDebugAccess({:type => "boolean"}, @scenario.student_debug_access)
  xml.goal({:type => "String"}, @scenario.goal)
  xml.level({:type => "Integer"}, @scenario.level)
  xml.client do
    xml.version({:type => "String"}, @scenario.master_scenario.client_version.version)
    xml.url({:type => "String"}, @scenario.master_scenario.client_version.url)
    xml.release_date({:type => "Date"}, @scenario.master_scenario.client_version.release_date)
  end
  xml.shortDescription({:type => "String"}, @scenario.short_description)
  xml.description({:type => "String"}, @scenario.description)
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
      SystemVariableFields::COMPONENTS.each_pair do |code, name|
        xml.systemNode({:id => code, :name => name}) do
          @scenario.scenario_variables.where("component_code" => code).each do |variable|
              xml.sysVar do
                xml.name({:type => "String"}, variable.name)
                xml.displayName({:type => "String"}, variable.display_name)
                xml.description({:type => "String"}, variable.description)
                xml.index({:type => "Integer"}, variable.index)
                xml.lowValue({:type => "Float"}, variable.low_value)
                xml.highValue({:type => "Float"}, variable.high_value)
                xml.initialValue({:type => "Float"}, variable.initial_value)
                xml.ioType({:type => "String"}, variable.io_type)
                xml.viewType({:type => "String"}, variable.view_type.upcase)
                xml.unitSI({:type => "String"}, variable.unit_si)
                xml.SItoIP({:type => "String"}, variable.si_to_ip)
                xml.unitIP({:type => "String"}, variable.unit_ip)
                xml.disabled({:type => "Boolean"}, variable.disabled)
                xml.isFault({:type => "Boolean"}, variable.is_fault)
                if variable.is_fault
                  xml.faultWidgetType({:type => "String"}, variable.fault_widget_type)
                  xml.faultIsActive({:type => "Boolean"}, variable.fault_is_active)
                  xml.subsection({:type => "String"}, variable.subsection)
                  xml.leftLabel({:type => "String"}, variable.left_label)
                  xml.rightLabel({:type => "String"}, variable.right_label)
                  xml.zonePosition({:type => "String"}, variable.zone_position)
                  xml.isPercentage({:type => "Boolean"}, variable.is_percentage)
                end
              end
          end
        end
      end
    end
end