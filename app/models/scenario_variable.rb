class ScenarioVariable < Variable
  belongs_to :scenario
  
  validates_presence_of :scenario
end
