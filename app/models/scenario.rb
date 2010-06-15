class Scenario
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Document::ProtectedAttributes
  include Xml
  include ScenarioFields
  include ActiveModel::Validations
      
  embed_many :scenario_variables
  embed_many :scenario_alerts
  
  belongs_to_related :user
  belongs_to_related :master_scenario
  has_many_related :group_scenarios
  
  validates_presence_of :name, :master_scenario_id, :user, :longterm_start_date, :longterm_stop_date, :realtime_start_date
  validates_format_of :longterm_start_date, :longterm_stop_date, :realtime_start_date, :with => /\d{2}\/\d{2}\/\d{4}/, :message => "is invalid"
  validate :longterm_validator

  named_scope :recently_created, criteria.where(:created_at.gt => (Time.now + 30.days))
  named_scope :recently_updated, criteria.where(:updated_at.gt => (Time.now + 30.days))
  named_scope :public, criteria.where(:public => true)
    
  attr_protected :user_id
  
  before_create :set_master_scenario_version
  after_create :copy_system_variables
  
  def groups
    groups_ids = group_scenarios.collect { |gs| gs.group_id }
    Group.find(groups_ids)
  end
  
  def master_scenario
    begin
      ms = MasterScenario.find(self.master_scenario_id)
      ms_version = self.master_scenario_version
      (self.new_record? or ms.version == ms_version) ? ms : ms.versions.detect { |v| v.version == ms_version }
    rescue
      nil
    end
  end
    
  private
    
  def longterm_validator
    errors.add(:longterm_start_date, "should be set before the longterm stop date") if longterm_start_date >= longterm_stop_date
    errors.add(:longterm_stop_date, "should be set after the longterm start date") if longterm_stop_date <= longterm_start_date
    errors.add(:realtime_start_date, "should be set between start and stop dates") if (realtime_start_date < longterm_start_date) or (realtime_start_date > longterm_stop_date) 
  end
  
  def set_master_scenario_version
    self.master_scenario_version = master_scenario.version
  end
  
  def copy_system_variables
    self.master_scenario.system_variables.each do |sv|
      self.scenario_variables.create sv.attributes.except("_id", "_type")
    end
  end
end
