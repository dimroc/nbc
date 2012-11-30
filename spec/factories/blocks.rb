FactoryGirl.define do
  factory :block do
    point { Mercator::FACTORY.point(-73, 40.72975).projection }

    factory :block_video, class: Block::Video do
      video
    end
  end
end
