Factory.define :user do |user|
  user.login 'jdoe'
  user.first_name 'James'
  user.last_name 'Doe'
  user.email 'jdoe@builder.com'
  user.password 'jdoe1234'
  user.password_confirmation 'jdoe1234'
  user.enabled true
end