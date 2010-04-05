class Scenario
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Document::ProtectedAttributes
  include ScenarioFields
  include ActiveModel::Validations
    
  embed_many :scenario_variables
  belongs_to_related :user
  belongs_to_related :master_scenario
  
  attr_accessor :realtime_start_date, :realtime_start_hour, :realtime_start_minute, :realtime_meridiem
  
  validates_presence_of :name, :master_scenario_id, :user, :longterm_start_date, :longterm_stop_date, :realtime_start_date
  validates_format_of :longterm_start_date, :longterm_stop_date, :realtime_start_date, :with => /\d{2}\/\d{2}\/\d{4}/, :message => "is invalid"

  named_scope :recently_created, criteria.where(:created_at.gt => (Time.now + 30.days))
  named_scope :recently_updated, criteria.where(:updated_at.gt => (Time.now + 30.days))
    
  attr_protected :user_id
  
  before_save  :set_realtime_start_datetime
  after_create :copy_system_variables
  
  
  # Create new module to support datetime with mongoid like this.
  def realtime_start_date
    @realtime_start_date || (parsed_realtime_start.strftime("%m/%d/%Y") if parsed_realtime_start)
  end
  
  def realtime_start_hour
    @realtime_start_hour || parsed_realtime_start.try(:hour)
  end

  def realtime_start_minute
    @realtime_start_minute || parsed_realtime_start.try(:min)
  end
  
  def realtime_meridiem
    @realtime_meridiem || (parsed_realtime_start.strftime("%p") if parsed_realtime_start)
  end
  
  def parsed_realtime_start
    Time.parse(read_attribute(:realtime_start_datetime)).localtime if read_attribute(:realtime_start_datetime)
  end

  private
  
  def set_realtime_start_datetime
    write_attribute(:realtime_start_datetime, Time.parse("#{realtime_start_date} #{realtime_start_hour}:#{realtime_start_minute} #{realtime_meridiem}"))
  end
  
  def copy_system_variables
    self.master_scenario.system_variables.each do |system_variables|
      sys_var_attributes = system_variables.attributes
      sys_var_attributes.delete("_id")
      sys_var_attributes.delete("_type")
      self.scenario_variables.create(sys_var_attributes)
    end
  end
  
end
