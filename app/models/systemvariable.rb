class Systemvariable < ActiveRecord::Base

  has_many :scenario_systemvariables, :dependent=>:destroy
  has_many :scenarios, :through=>:scenario_systemvariables
	
  belongs_to :component
	
	validates_presence_of :name
	validates_presence_of :display_name
	validates_presence_of :min_value
	validates_presence_of :default_value
	validates_presence_of :max_value    
	validates_numericality_of :min_value
  validates_numericality_of :default_value
  validates_numericality_of :max_value

	validates_presence_of :component, :message => ": Please select the component this variable belongs to."
  validates_associated :component

	
  validates_inclusion_of :typeID,
                          :in => ["INPUT","OUTPUT"],
                          :message => "-- Valid types are INPUT and OUTPUT"
  
  validates_inclusion_of :si_to_ip,
                          :in => [nil, '','SI*1.8+32', 'SI*1.8','SI*1765.7', 'SI*15.847861', 'SI*15.88', 'SI*0.2931', 'SI*1.895', 'SI/249.1' ,'SI*1.45e-4','SI*1.47e-4'],
                          :message => "-- if present, the SI to IP conversion must be typed EXACTLY as one of the following conversions: <br/>SI*1.8+32<br/>SI*1.8<br/>SI*1765.7<br/>SI*15.847861<br/> SI*15.88 <br/>SI*0.2931 <br/>SI*1.895<br/>SI/249.1<br/>SI*1.45e-4<br/>SI*1.47e-4"

  validates_inclusion_of :fault_widget_type,
													:in => ['slider','checkbox', 'SLIDER','CHECKBOX'],
													:message => "-- Valid types are \"slider\" and \"checkbox\"",
													:if => :is_fault
													
  validates_inclusion_of :zone_position,
													:in => ['left','center','right','no_gradient','LEFT','CENTER','RIGHT','NO_GRADIENT'],
													:message => "-- Valid zone positions are \"left\", \"center\" , \"right\" and \"no_gradient\"",
													:if => :is_fault
													
end
