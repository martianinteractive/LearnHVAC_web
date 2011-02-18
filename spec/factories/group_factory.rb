Factory.define :group do |group|
  group.name 'class01'
  group.code 'axd3fdx'
end

Factory.define :valid_group, :class => Group do |group|
  group.name 'valid'
  group.code 'myvalidgroup'
  group.creator { Factory(:admin) }
  group.scenarios { [Factory(:valid_scenario)] }
end
