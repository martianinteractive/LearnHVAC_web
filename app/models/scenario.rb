class Scenario < ActiveRecord::Base      
  belongs_to :user
  belongs_to :master_scenario
  belongs_to :client_version,   :foreign_key => "desktop_id"
  has_many :variables,          :class_name => "ScenarioVariable", :dependent => :destroy
  has_many :alerts,             :class_name => "ScenarioAlert"
  has_many :group_scenarios,    :dependent => :destroy
  has_many :groups,             :through => :group_scenarios
  has_many :user_scenarios,     :dependent => :destroy
  has_many :users,              :through => :user_scenarios
  
  validates_presence_of :master_scenario, :user, :longterm_start_date, :longterm_stop_date, :realtime_start_datetime
  validates :name, :presence => true, :length => {:within => 1..180}
  validate :longterm_validator
  
  before_create :set_client_version
  after_create :copy_variables
  after_create :create_user_scenario
  
  scope :recently_created, where(["scenarios.created_at > ?", 30.days.ago.utc])
  scope :recently_updated, where(["scenarios.updated_at > ?", 30.days.ago.utc])
  scope :public, where(:public => true)
  scope :with_unread_alerts, where("scenario_alerts.read" => false)
    
  private
  
  def set_client_version
    self.client_version = master_scenario.client_version
  end
  
  def copy_variables
    master_scenario.variables.each do |sys_var|
      variables.create sys_var.attributes.except("id", "created_at", "updated_at", "scenario_id")
    end
  end
  
  def longterm_validator
    errors.add(:longterm_start_date, "should be set before the longterm stop date") if longterm_start_date >= longterm_stop_date
    errors.add(:longterm_stop_date, "should be set after the longterm start date") if longterm_stop_date <= longterm_start_date
    errors.add(:realtime_start_datetime, "should be set between start and stop dates") if (realtime_start_datetime < longterm_start_date) or (realtime_start_datetime > longterm_stop_date) 
  end
  
  def create_user_scenario
    UserScenario.create(:scenario => self, :user => self.user)
  end
  
end
