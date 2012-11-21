FactoryGirl.define do
  factory :region do
    name { Faker::AddressUS.state }
    after(:build) do |region|
      region.neighborhoods << Neighborhood.first
    end
  end

  factory :region_with_geometry, parent: :region do
    ignore do
      left 0
      bottom 0
      width 9
      height 9
    end

    after(:build) do |region, evaluator|
      left = evaluator.left
      bottom = evaluator.bottom
      width = evaluator.width
      height = evaluator.height

      region.geometry = GeometryHelper.rectangle left, bottom, width, height
    end
  end
end
