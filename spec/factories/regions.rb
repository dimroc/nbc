FactoryGirl.define do
  factory :region do
    ignore do
      width 10
      height 10
    end

    name { Faker::AddressUS.state }

    after(:build) do |region, evaluator|
      (0...evaluator.width).each do |left|
        (0...evaluator.height).each do |top|
          region.blocks << Block.new(left: left, top: top)
        end
      end
    end
  end
end
