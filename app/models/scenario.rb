class Scenario
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Document::ProtectedAttributes
  include ScenarioFields
  
  has_many :scenario_variables
  belongs_to_related :user
  
  named_scope :recently_created, criteria.where(:created_at.gt => (Time.now + 30.days))
  named_scope :recently_updated, criteria.where(:updated_at.gt => (Time.now + 30.days))
  
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
