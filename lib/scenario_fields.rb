module ScenarioFields
  def self.included(parent)
    parent.field :name
    parent.field :short_description
    parent.field :description
    parent.field :goal
    parent.field :longterm_start_date,             :default => Time.now.beginning_of_year.strftime("%m/%d/%Y")
    parent.field :longterm_stop_date,              :default => Time.now.beginning_of_year.end_of_month.strftime("%m/%d/%Y")
    parent.field :realtime_start_datetime,         :default => (Time.now.beginning_of_year + 14.days).strftime("%m/%d/%Y")
    parent.field :level,                           :type => Integer, :default => 1
    parent.field :inputs_visible,                  :type => Boolean, :default => true
    parent.field :inputs_enabled,                  :type => Boolean, :default => true
    parent.field :faults_visible,                  :type => Boolean, :default => true
    parent.field :faults_enabled,                  :type => Boolean, :default => true
    parent.field :valve_info_enabled,              :type => Boolean, :default => true
    parent.field :allow_longterm_date_change,      :type => Boolean, :default => false
    parent.field :allow_realtime_datetime_change,  :type => Boolean, :default => false
    
    attr_accessor :realtime_start_date, :realtime_start_hour, :realtime_start_minute, :realtime_meridiem
    
    parent.send :include, InstanceMethods
    parent.before_validate :set_realtime_start_datetime
  end
  
  module InstanceMethods
    
    # For now let's put this code here, later, if we need to support more datetime fields we can move this to a general Mongoid module.
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
  end
  
end
