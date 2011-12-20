class Scenario < ActiveRecord::Base

  # - Relationships -
  belongs_to :original_author,  :class_name => 'User'
  belongs_to :user
  belongs_to :master_scenario
  belongs_to :client_version,   :foreign_key => "desktop_id"
  has_many :variables,          :class_name => "ScenarioVariable", :dependent => :destroy
  has_many :group_scenarios,    :dependent => :destroy
  has_many :groups,             :through => :group_scenarios
  has_many :memberships,        :dependent => :destroy
  has_many :users,              :through => :memberships, :source => :member
  has_many :individual_memberships
  has_many :group_memberships
  #has_many :alerts,             :class_name => "ScenarioAlert"

  # - Validations -
  validates_presence_of :user, :longterm_start_date, :longterm_stop_date, :realtime_start_datetime
  validates_presence_of :master_scenario, :on => :create
  validates :name, :presence => true, :length => {:within => 1..180}
  validate :longterm_validator

  # - Callbacks -
  before_create :set_client_version
  after_create :copy_variables
  after_create :create_creator_membership
  before_update :reassign_creator_membership, :if => :user_id_changed?

  # - Scopes -
  scope :recently_created, where(["scenarios.created_at > ?", 30.days.ago.utc])
  scope :recently_updated, where(["scenarios.updated_at > ?", 30.days.ago.utc])
  scope :public, where(:public => true)
  scope :with_unread_alerts, where("scenario_alerts.read" => false)
  scope :sample, where(:sample => true)
  scope :shared, where(:shared => true)

  # - Instance Methods -
  def belongs_to_user?(user)
    self.user.eql? user
  end

  def is_a_clone?
    original_author_id.present?
  end

  def clone_for(new_user)
    unless new_user.has_role? :instructor
      raise ArgumentError, "Instructor expected. Got #{new_user.role.to_s.titleize}"
    end
    clone_atts = attributes.except("id", "created_at", "updated_at", "user_id", "sample", "shared")
    clone_atts.merge!(:user_id => new_user.id, :original_author_id => user.id)
    new_scenario = self.class.new clone_atts
    if new_scenario.save
      clone_variables_for new_scenario
    end
    new_scenario
  end

  def clone_variables_for(scenario)
    query = <<-SQL
    INSERT INTO `variables` (`name`, `display_name`, `description`, `unit_si`, `unit_ip`, `si_to_ip`, `left_label`, `right_label`, `subsection`, `zone_position`, `fault_widget_type`, `notes`, `component_code`, `io_type`, `view_type`, `index`, `lock_version`, `node_sequence`, `low_value`, `high_value`, `initial_value`, `is_fault`, `is_percentage`, `disabled`, `fault_is_active`, `type`, `scenario_id`)
    SELECT `name`, `display_name`, `description`, `unit_si`, `unit_ip`, `si_to_ip`, `left_label`, `right_label`, `subsection`, `zone_position`, `fault_widget_type`, `notes`, `component_code`, `io_type`, `view_type`, `index`, `lock_version`, `node_sequence`, `low_value`, `high_value`, `initial_value`, `is_fault`, `is_percentage`, `disabled`, `fault_is_active`, 'ScenarioVariable', #{scenario.id} FROM `variables` WHERE `variables`.`scenario_id` = #{id} AND `variables`.`type` IN ('ScenarioVariable')
    SQL
    ActiveRecord::Base.connection.execute query
    scenario.variables
  end

  private

  def set_client_version
    self.client_version = master_scenario.client_version
  end

  def copy_variables
    return if is_a_clone?
    query = <<-SQL
    INSERT INTO `variables` (`name`, `display_name`, `description`, `unit_si`, `unit_ip`, `si_to_ip`, `left_label`, `right_label`, `subsection`, `zone_position`, `fault_widget_type`, `notes`, `component_code`, `io_type`, `view_type`, `index`, `lock_version`, `node_sequence`, `low_value`, `high_value`, `initial_value`, `is_fault`, `is_percentage`, `disabled`, `fault_is_active`, `type`, `scenario_id`)
    SELECT `name`, `display_name`, `description`, `unit_si`, `unit_ip`, `si_to_ip`, `left_label`, `right_label`, `subsection`, `zone_position`, `fault_widget_type`, `notes`, `component_code`, `io_type`, `view_type`, `index`, `lock_version`, `node_sequence`, `low_value`, `high_value`, `initial_value`, `is_fault`, `is_percentage`, `disabled`, `fault_is_active`, 'ScenarioVariable', #{id} FROM `variables` WHERE `variables`.`scenario_id` = #{master_scenario_id} AND `variables`.`type` IN ('SystemVariable')
    SQL
    ActiveRecord::Base.connection.execute query
  end

  def longterm_validator
    errors.add(:longterm_start_date, "should be set before the longterm stop date") if longterm_start_date >= longterm_stop_date
    errors.add(:longterm_stop_date, "should be set after the longterm start date") if longterm_stop_date <= longterm_start_date
    errors.add(:realtime_start_datetime, "should be set between start and stop dates") if (realtime_start_datetime < longterm_start_date) or (realtime_start_datetime > longterm_stop_date)
  end

  def create_creator_membership
    IndividualMembership.create(:scenario => self, :member => user)
  end

  def reassign_creator_membership
    old_user_id, new_user_id = user_id_change
    m = individual_memberships.find_by_member_id(old_user_id)
    m.destroy unless m.update_attributes(:member_id => new_user_id)
    m
  end

end
