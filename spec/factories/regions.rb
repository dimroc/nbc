FactoryGirl.define do
  factory :region do
    name { Faker::AddressUS.state }
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

      factory = Cartesian::preferred_factory()

      linear_ring = factory.linear_ring([
        factory.point(left, bottom),
        factory.point(left, bottom + height),
        factory.point(left + width, bottom + height),
        factory.point(left + width, bottom)])

      region.geometry = factory.polygon(linear_ring)
    end
  end
end
