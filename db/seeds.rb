User.create!(name: 'Bartosz Kita',
             email: 'bartosz@kita.email',
             password: 'password',
             password_confirmation: 'password',
             admin: true)

99.times do |num|
  name = Faker::Name.name
  email = "test-user-#{num}@testemail.com"
  password = "password"

  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end
