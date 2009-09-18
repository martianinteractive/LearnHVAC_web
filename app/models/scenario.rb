class Scenario < ActiveRecord::Base
  
  has_many :scenario_systemvariables, :dependent=>:destroy
  has_many :systemvariables, :through=> :scenario_systemvariables 
  belongs_to :weatherfile
  belongs_to :institution
  acts_as_list

  validates_presence_of :scenID, :message => "Scenario ID must be entered."
  validates_uniqueness_of :scenID,  :message => "Scenario ID must be unique."  
  validates_format_of :scenID, :with => /^[a-zA-Z][a-zA-Z0-9]+$/, :message => "Scenario can only contain letters and numbers. (No spaces!)"
  validates_numericality_of :level, :only_integer=>true, :less_than=>6, :greater_than=>0, :message=> "Please pick a number between 1 and 5"
 
  def longterm_start_date_formatted
    self.longterm_start_date.strftime "%m/%d"
  end
  
  def longterm_stop_date_formatted
    self.longterm_stop_date.strftime "%m/%d"
  end
 
  def realtime_start_datetime_formatted
    self.realtime_start_datetime.strftime "%m/%d/%Y %H:%M"
  end
 
    def get_xml

        #add scenario info to xml
        xml = "<scenario id=\"" + self.id.to_s + "\"\n"
        xml = xml + "          scenID=\"" + self.scenID + "\"\n"
        xml = xml + "          name=\""+self.name+"\"\n"
        xml = xml + "          short_description=\""+self.short_description+"\"\n" unless self.short_description.nil?
        xml = xml + "          goal=\"" +self.goal + "\"\n" unless self.goal.nil?
        xml = xml + "          thumbnail_URL=\"" + self.thumbnail_URL+"\"\n" unless self.thumbnail_URL.nil?
        xml = xml + "          longterm_start_date=\"" + self.longterm_start_date_formatted+"\"\n" unless self.longterm_start_date.nil?
        xml = xml + "          longterm_stop_date=\"" + self.longterm_stop_date_formatted+"\"\n" unless self.longterm_stop_date.nil?
        xml = xml + "          allow_longterm_date_change=\"" + self.allow_longterm_date_change.to_s+"\"\n" unless self.allow_longterm_date_change.nil?       
        xml = xml + "          realtime_start_datetime=\"" + self.realtime_start_datetime_formatted+"\"\n" unless self.realtime_start_datetime.nil?
        xml = xml + "          allow_realtime_datetime_change=\"" + self.allow_realtime_datetime_change.to_s+"\"\n" unless self.allow_realtime_datetime_change.nil?
        xml = xml + "          force_long_term_sim=\"" + self.force_long_term_sim.to_s+"\">\n" unless self.force_long_term_sim.nil?

        #add iputArea info to xml
        xml = xml + "<!-- Input Area -->\n"
        xml = xml + "<inputPanel visible=\"" + self.inputs_visible.to_s + "\" enabled=\"" + self.inputs_enabled.to_s + "\" />\n"
        xml = xml + "<faultPanel visible=\"" + self.faults_visible.to_s + "\" enabled=\"" + self.faults_enabled.to_s + "\" />\n\n"

        #add assets info
        xml = xml + "<!-- assets -->\n"
        xml = xml + "<scenarioMovie url=\"" + self.movie_URL + "\"/>\n\n"

        #add visualization info
        xml = xml + "<!-- visualization -->\n"
        xml = xml + "<visualizationPanel enableDragSensor=\"" + self.drag_sensor_enabled.to_s + "\""
        xml = xml + "                    showValveInfoWindow=\"" + self.valve_info_enabled.to_s +  "\"    />\n\n"

        #add outputArea info to xml
        xml = xml + "<!-- outputArea -->\n"
        xml = xml + "<outputPanel useCustomOutputGraphs=\"" + self.use_custom_output_graphs.to_s + "\" />\n"

        #System variables --------

        xml = xml + "<!-- System Variables -->\n"
        xml = xml + "<sysVars>\n"

        currNodeID = ""
        addedNodes = []

        # BIG NOTE: unfortunate naming, but component_id column for Component model is actually 
        # the component's ePrimer ID : stuff like "HC", "CC", etc.
        # it's not the same as the component_id index column used in scenario_systemvariables and systemvariables tables        
        
        # systemVariables = Systemvariable.find(:all, :include => :scenario_systemvariables, :order=>'component_id, typeID, is_fault, node_sequence')
        
        sysVars = self.scenario_systemvariables.find(:all, :include => {:systemvariable => :component}, :order => "systemvariables.component_id")
        sysVars.each do |sysVar|
      
        #systemvariable = var.systemvariable
        #for systemvariable in systemVariables

          #sysVar = self.scenario_systemvariables.find_by_systemvariable_id(systemvariable.id)

          #check if next component ... if so, create xml element to hold children system variables
          if sysVar.systemvariable.component_id != currNodeID

            #close previous systemNode if not first component
            if currNodeID != ""
              xml = xml + "\t</systemNode>\n\n"
            end  

            currNodeID = sysVar.systemvariable.component_id

            xml = xml + "\t<systemNode id=\"" + sysVar.systemvariable.component.component_id + "\" name = \"" + sysVar.systemvariable.component.name + "\" >\n"

            #remember that this component has been added so we can add empty elements for remaining components at end
            addedNodes << currNodeID

          end

          #add system variable
          xml = xml + "\t\t<sysVar\n"
          xml = xml + "\t\t\t name=\"" + sysVar.systemvariable.name.to_s + "\"\n"
          xml = xml + "\t\t\t display_name=\""  + sysVar.systemvariable.display_name.to_s + "\"\n"
          xml = xml + "\t\t\t description=\""  + sysVar.systemvariable.description.to_s + "\"\n"
          #write min value differently if fault
          if sysVar.systemvariable.is_fault == true
            xml = xml + "\t\t\t min_value=\"-999\"\n"
          else
            xml = xml + "\t\t\t min_value=\""  + sysVar.systemvariable.min_value.to_s + "\"\n"
          end
          xml = xml + "\t\t\t low_value=\""  + sysVar.low_value.to_s + "\"\n"
          xml = xml + "\t\t\t initial_value=\""  + sysVar.initial_value.to_s + "\"\n"
          xml = xml + "\t\t\t high_value=\""  + sysVar.high_value.to_s + "\"\n"
          xml = xml + "\t\t\t max_value=\""  + sysVar.systemvariable.max_value.to_s + "\"\n"
          xml = xml + "\t\t\t typeID=\""  + sysVar.systemvariable.typeID.to_s + "\"\n"
          xml = xml + "\t\t\t applicationID=\""  + sysVar.applicationID.to_s + "\"\n"
          xml = xml + "\t\t\t unit_si=\""  + sysVar.systemvariable.unit_si.to_s + "\"\n"
          xml = xml + "\t\t\t si_to_ip=\""  + sysVar.systemvariable.si_to_ip.to_s + "\"\n"
          xml = xml + "\t\t\t unit_ip=\""  + sysVar.systemvariable.unit_ip.to_s + "\"\n"
          if sysVar.systemvariable.global_disable == true
            xml = xml + "\t\t\t disabled=\"true\"\n"
          else  
            xml = xml + "\t\t\t disabled=\""  + sysVar.disabled.to_s + "\"\n"
          end 

          #add in fault properties if fault
          if sysVar.systemvariable.is_fault == true
            xml = xml + "\t\t\t is_fault = \"true\"\n"
            xml = xml + "\t\t\t left_label=\"" + sysVar.systemvariable.left_label.to_s + "\"\n"
            xml = xml + "\t\t\t right_label=\"" + sysVar.systemvariable.right_label.to_s + "\"\n"
            xml = xml + "\t\t\t subsection=\"" + sysVar.systemvariable.subsection.to_s + "\"\n"
            xml = xml + "\t\t\t zone_position=\"" + sysVar.systemvariable.zone_position.to_s + "\"\n"
            xml = xml + "\t\t\t is_percentage=\"" + sysVar.systemvariable.is_percentage.to_s + "\"\n"
            xml = xml + "\t\t\t fault_widget_type=\"" + sysVar.systemvariable.fault_widget_type.to_s + "\"\n"
          else
            xml = xml + "\t\t\t is_fault = \"false\"\n";
          end

          xml = xml + "\t\t/>\n\n"

        end

        xml = xml + "\t</systemNode>\n"

        #ADD IN ANY NODES WITH NO SYSTEM VARIABLES
        components = Component.find(:all)
        for component in components
          if addedNodes.include? component.id
            #do nothing (there must be a better ruby idiom for this)
          else 
            xml = xml + "\t<systemNode id=\"" + component.component_id + "\" name= \"" + component.name + "\" />\n\n"
          end
        end

        xml = xml + "</sysVars>\n"
        xml = xml + "</scenario>\n"

  	end


  end
