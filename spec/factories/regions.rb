FactoryGirl.define do
  factory :region do
    ignore do
      width 10
      height 10
    end

    name { Faker::AddressUS.state }

    after(:build) do |region, evaluator|
      (0...evaluator.width).each do |left|
        (0...evaluator.height).each do |bottom|
          region.blocks.build(left: left, bottom: bottom)
        end
      end
    end
  end
end
