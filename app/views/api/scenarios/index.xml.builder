for scenario in @scenarios
  xml.scenario do 
    xml.name(scenario.name) 
    xml.description(scenario.description) 
  end
end
