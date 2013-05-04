namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
  end
end

def make_users
  admin = User.create!(name:     "admin",
                       email:    "admin@silb.com",
                       password: "admin",
                       password_confirmation: "admin")
  admin.toggle!(:admin)
  admin.activate!
  10.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@silb.org"
    password  = "password"
    user = User.create!(name:     name,
                        email:    email,
                        password: password,
                        password_confirmation: password)
    user.activate!
  end
end

