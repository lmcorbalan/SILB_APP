require 'csv'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_countries_ragions_cities
  end
end

def make_users
  admin = User.create!(name:     "admin",
                       email:    "admin@silb.com",
                       password: "admin123",
                       password_confirmation: "admin123")
  admin.toggle!(:admin)
  admin.activate!
  10.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@silb.org"
    password  = "foobar"
    user = User.create!(name:     name,
                        email:    email,
                        password: password,
                        password_confirmation: password)
    user.activate!
  end
end

def make_countries_ragions_cities
  CSV.foreach("#{Rails.root}/public/seed_data/worldSeed.csv", {
    :headers => true, :header_converters => :symbol
  }) do |row|
    country = Country.find_by_name(row[:country]) || Country.create(name:row[:country])
    region = country.regions.find_by_name(row[:region]) || country.regions.build(name:row[:region])
    city = region.cities.find_by_name(row[:city]) || region.cities.build(name:row[:city])
    region.save!
  end
end

