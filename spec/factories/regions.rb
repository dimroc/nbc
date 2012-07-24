FactoryGirl.define do
  factory :region do
    name { Faker::AddressUS.state }
  end

  factory :region_with_geometry, parent: :region do
    ignore do
      width 9
      height 9
    end

    after(:build) do |region, evaluator|
      width = evaluator.width
      height = evaluator.height
      factory = Cartesian::preferred_factory()

      linear_ring = factory.linear_ring([
        factory.point(0,0),
        factory.point(0,height),
        factory.point(width,height),
        factory.point(width,0)])

      region.geometry = factory.polygon(linear_ring)
    end
  end
end
