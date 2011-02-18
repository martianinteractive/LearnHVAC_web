Factory.define :user do |user|
  user.login 'jdoe'
  user.first_name 'James'
  user.last_name 'Doe'
  user.email 'jdoe@builder.com'
  user.password 'jdoe1234'
  user.password_confirmation 'jdoe1234'
  user.enabled true
  user.country 'United States'
  user.city 'Bethesda'
  user.state 'Maryland'
  user.terms_agreement "1"
  user.role_code User::ROLES[:instructor]
end

Factory.define :student, :class => User do |user|
  user.login 'peter'
  user.first_name 'Peter'
  user.last_name 'Doe'
  user.email 'peter@builder.com'
  user.password 'peter222'
  user.password_confirmation 'peter222'
  user.role_code 1
  user.enabled true
  user.country 'United States'
  user.city 'Bethesda'
  user.state 'Maryland'
  user.terms_agreement "1"
end

Factory.define :instructor, :class => User do |user|
  user.login 'joeyb'
  user.first_name 'Joe'
  user.last_name 'Boe'
  user.email 'jboe@builder.com'
  user.password 'jboe333'
  user.password_confirmation 'jboe333'
  user.role_code 2
  user.enabled true
  user.country 'United States'
  user.city 'Bethesda'
  user.state 'Maryland'
  user.terms_agreement "1"
end

Factory.define :manager, :class => User do |user|
  user.login 'loreng'
  user.first_name 'loren'
  user.last_name 'Goey'
  user.email 'joreng@builder.com'
  user.password 'jboe333'
  user.password_confirmation 'jboe333'
  user.role_code 3
  user.enabled true
  user.country 'United States'
  user.city 'Bethesda'
  user.state 'Maryland'
  user.terms_agreement "1"
end

Factory.define :admin, :class => User do |user|
  user.login 'tonyal'
  user.first_name 'tonya'
  user.last_name 'love'
  user.email 'tolove@builder.com'
  user.password 'blawasdf'
  user.password_confirmation 'blawasdf'
  user.role_code 4
  user.enabled true
  user.country 'United States'
  user.city 'Bethesda'
  user.state 'Maryland'
  user.terms_agreement "1"
end

Factory.define :guest, :class => User do |user|
  user.login 'louist'
  user.first_name 'louis'
  user.last_name 'Troy'
  user.email 'louist@builder.com'
  user.password 'blawasdf'
  user.password_confirmation 'blawasdf'
  user.role_code 0
  user.enabled true
  user.country 'United States'
  user.city 'Bethesda'
  user.state 'Maryland'
  user.terms_agreement "1"
end

Factory.define :ucla_user, :class => User do |user|
  user.login 'timmy'
  user.first_name 'Tim'
  user.last_name 'Blum'
  user.email 'tim@blum.com'
  user.password 'jboe333'
  user.password_confirmation 'jboe333'
  user.role_code 2
  user.enabled true
  user.country 'United States'
  user.city 'Bethesda'
  user.state 'Maryland'
  user.terms_agreement "1"
  user.institution { Factory(:institution, :name => "UCLA") }
end