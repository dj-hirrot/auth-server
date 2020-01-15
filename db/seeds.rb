User.create!(
  name: 'Example User',
  email: 'example@sample.org',
  password: 'foobar',
  password_confirmation: 'foobar'
)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@sample.org"
  password = 'password'
  User.create!(name: name, email: email, password: password, password_confirmation: password)
end
