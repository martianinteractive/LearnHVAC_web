class Scenario < ActiveRecord::Base
  include Xml
      
  belongs_to :user
  belongs_to :master_scenario
  
  has_many :variables, :class_name => "ScenarioVariable"
  has_many :alerts, :class_name => "ScenarioAlert"
  has_many :group_scenarios
  
  validates_presence_of :name, :master_scenario_id, :user, :longterm_start_date, :longterm_stop_date, :realtime_start_date
  validates_format_of :longterm_start_date, :longterm_stop_date, :realtime_start_date, :with => /\d{2}\/\d{2}\/\d{4}/, :message => "is invalid"
  # validate :longterm_validator
  
  scope :recently_created, where(["created_at > ?", 30.days.ago.utc])
  scope :recently_updated, where(["updated_at > ?", 30.days.ago.utc])
  scope :public, where(:public => true)
  scope :with_unread_alerts, where("scenario_alerts.read" => false)
  
  # belongs_to_related :user
  # belongs_to_related :master_scenario
  # belongs_to_related :client_version
  # has_many_related :group_scenarios
  # 
  # before_create :copy_master_scenario_attributes
  # after_create :copy_system_variables
  # 
  # def groups
  #   groups_ids = group_scenarios.collect { |gs| gs.group_id }
  #   Group.find(groups_ids)
  # end
  # 
  # def master_scenario
  #   begin
  #     ms = MasterScenario.find(self.master_scenario_id)
  #     ms_version = self.master_scenario_version
  #     (self.new_record? or ms.version == ms_version) ? ms : ms.versions.detect { |v| v.version == ms_version }
  #   rescue
  #     nil
  #   end
  # end
  #   
  # private
  #   
  # def longterm_validator
  #   errors.add(:longterm_start_date, "should be set before the longterm stop date") if longterm_start_date >= longterm_stop_date
  #   errors.add(:longterm_stop_date, "should be set after the longterm start date") if longterm_stop_date <= longterm_start_date
  #   errors.add(:realtime_start_date, "should be set between start and stop dates") if (realtime_start_date < longterm_start_date) or (realtime_start_date > longterm_stop_date) 
  # end
  # 
  # def copy_master_scenario_attributes
  #   self.master_scenario_version = master_scenario.version
  #   self.master_scenario_name = master_scenario.name
  #   self.client_version_id = master_scenario.client_version.id
  # end
  # 
  # def copy_system_variables
  #   self.master_scenario.system_variables.each do |sv|
  #     self.scenario_variables.create sv.attributes.except("_id", "_type")
  #   end
  # end
end
