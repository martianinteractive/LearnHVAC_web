Factory.define :user do |user|
  user.login 'jdoe'
  user.name 'James Doe'
  user.email 'jdoe@builder.com'
  user.password 'jdoe1234'
  user.password_confirmation 'jdoe1234'
end