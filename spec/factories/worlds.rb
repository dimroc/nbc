FactoryGirl.define do
  factory :world do
    name { Faker::AddressUS.state }
  end

  factory :world_with_regions, parent: :world do
    after(:build) do |world, evaluator|
      world.regions << FactoryGirl.build(:region_with_geometry)
      world.regions << FactoryGirl.build(:region_with_geometry, left: 10, bottom: 10)

      world.mercator_bounding_box_geometry = world.generate_bounding_box.to_geometry
      world.mesh_bounding_box_geometry = world.generate_mesh_bounding_box.to_geometry
      Loader::World.generate_threejs(world, 1, 1)
    end
  end
end
