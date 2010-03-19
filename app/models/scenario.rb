class Scenario
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Document::ProtectedAttributes
  
  field :scenario_id
  field :name
  field :movie_url
  field :thumbnail_url
  field :short_description
  field :description
  field :goal
  field :level,                           :type => Integer, :default => 1
  field :inputs_visible,                  :type => Boolean, :default => true
  field :inputs_enabled,                  :type => Boolean, :default => true
  field :faults_visible,                  :type => Boolean, :default => true
  field :faults_enabled,                  :type => Boolean, :default => true
  field :valve_info_enabled,              :type => Boolean, :default => true
  field :allow_longterm_date_change,      :type => Boolean, :default => false
  field :allow_realtime_datetime_change,  :type => Boolean, :default => false
  field :longterm_start_date,             :type => Date
  field :longterm_stop_date,              :type => Date
  field :realtime_start_datetime,         :type => DateTime  
  
  named_scope :recently_created, criteria.where(:created_at.gt => (Time.now + 30.days))
  named_scope :recently_updated, criteria.where(:updated_at.gt => (Time.now + 30.days))
  
  has_many :scenario_variables
  belongs_to_related :user
  
  accepts_nested_attributes_for :scenario_variables
  
  after_create :copy_system_variables
  
  attr_protected :user_id
  
  private
  
  def copy_system_variables
    user.system_variables.each do |isv|
      atts = isv.attributes
      atts.delete("_id")
      atts.delete("_type")
      self.scenario_variables.create(atts)
    end
  end
end
