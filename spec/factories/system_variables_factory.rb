Factory.define :global_system_variable do |global_system_variable|
  global_system_variable.name "a global system variable"
end

Factory.define :instructor_system_variable do |global_system_variable|
  global_system_variable.name "an instructor system variable"
end

Factory.define :scenario_system_variable do |system_variable|
  system_variable.name "a system variable"
end