FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { "secret sauce" }
  end
end
