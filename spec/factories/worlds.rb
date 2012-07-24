FactoryGirl.define do
  factory :world do
    name { Faker::AddressUS.state }
  end
end
