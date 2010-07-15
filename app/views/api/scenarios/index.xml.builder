xml.instruct!
xml.scenarios({:type => "array"}) do
  for scenario in @scenarios
    xml.scenario do
      xml.id({:type => "integer"}, scenario.id) 
      xml.studentDebugAccess({:type => "boolean"}, scenario.student_debug_access)
      xml.name({:type => "string"}, scenario.name) 
      xml.shortDescription({:type => "string"}, scenario.short_description) 
      xml.description({:type => "string"}, scenario.description) 
    end
  end
end