class Scenario < ActiveRecord::Base
  include Xml
      
  belongs_to :user
  belongs_to :master_scenario
  
  has_many :variables, :class_name => "ScenarioVariable"
  has_many :alerts, :class_name => "ScenarioAlert"
  has_many :group_scenarios
  
  validates_presence_of :name, :master_scenario_id, :user, :longterm_start_date, :longterm_stop_date, :realtime_start_date
  validates_format_of :longterm_start_date, :longterm_stop_date, :realtime_start_date, :with => /\d{2}\/\d{2}\/\d{4}/, :message => "is invalid"
  validate :longterm_validator
  
  scope :recently_created, where(["created_at > ?", 30.days.ago.utc])
  scope :recently_updated, where(["updated_at > ?", 30.days.ago.utc])
  scope :public, where(:public => true)
  scope :with_unread_alerts, where("scenario_alerts.read" => false)
  
  after_create :copy_variables
  
  private
  
  def copy_variables
    master_scenario.variables.each do |sys_var|
      variables.create sys_var.attributes.except("id", "created_at", "updated_at", "scenario_id")
    end
  end
  
  def longterm_validator
    errors.add(:longterm_start_date, "should be set before the longterm stop date") if longterm_start_date >= longterm_stop_date
    errors.add(:longterm_stop_date, "should be set after the longterm start date") if longterm_stop_date <= longterm_start_date
    errors.add(:realtime_start_date, "should be set between start and stop dates") if (realtime_start_date < longterm_start_date) or (realtime_start_date > longterm_stop_date) 
  end
  
  # def groups
  #   groups_ids = group_scenarios.collect { |gs| gs.group_id }
  #   Group.find(groups_ids)
  # end
  #   
  # private
  # 
  # def copy_system_variables
  #   self.master_scenario.system_variables.each do |sv|
  #     self.scenario_variables.create sv.attributes.except("_id", "_type")
  #   end
  # end
end
