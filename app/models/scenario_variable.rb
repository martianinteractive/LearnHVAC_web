class ScenarioVariable < Variable

  # - Relationships -
  belongs_to :scenario

  # - Validations -
  validates_presence_of :scenario_id
end
