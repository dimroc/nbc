FactoryGirl.define do
  factory :region do
    name { Faker::AddressUS.state }
  end
end
