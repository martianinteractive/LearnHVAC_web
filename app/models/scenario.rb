class Scenario
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Document::ProtectedAttributes
  include ScenarioFields
  include ActiveModel::Validations
    
  embed_many :scenario_variables
  belongs_to_related :user
  belongs_to_related :master_scenario
  
  validates_presence_of :name, :master_scenario_id, :user, :longterm_start_date, :longterm_stop_date#, :realtime_start_datetime
  validates_format_of :longterm_start_date, :longterm_stop_date, :with => /\d{2}\/\d{2}\/\d{4}/, :message => "is invalid"

  named_scope :recently_created, criteria.where(:created_at.gt => (Time.now + 30.days))
  named_scope :recently_updated, criteria.where(:updated_at.gt => (Time.now + 30.days))
    
  attr_protected :user_id
  
  after_create :copy_system_variables
  
  # def longterm_start_date
  #   read_attribute("longterm_start_date").strftime("%m/%d/%Y") if read_attribute("longterm_start_date")
  # end
  # 
  # def longterm_start_date=(value)
  #   write_attribute(:longterm_start_date, Time.parse(value).to_date) if value
  # end
  # 
  # def longterm_stop_date
  #   read_attribute("longterm_stop_date").strftime("%m/%d/%Y") if read_attribute("longterm_stop_date")
  # end
  # 
  # def longterm_stop_date=(value)
  #   write_attribute(:longterm_stop_date, Time.parse(value).to_date) if value
  # end
  
  # def realtime_start_datetime
  #   read_attribute("realtime_start_datetime").strftime("%m/%d/%Y") if read_attribute("realtime_start_datetime")
  # end
  # 
  # def realtime_start_datetime=(value)
  #   write_attribute(:realtime_start_datetime, Time.parse(value).to_date) if value
  # end

  private
  
  def copy_system_variables
    self.master_scenario.system_variables.each do |system_variables|
      sys_var_attributes = system_variables.attributes
      sys_var_attributes.delete("_id")
      sys_var_attributes.delete("_type")
      self.scenario_variables.create(sys_var_attributes)
    end
  end
  
end
