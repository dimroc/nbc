require 'spec_helper'

describe Loader::World do
  describe ".from_shapefile" do
    describe "generated square" do
      let(:world) { Loader::World.from_shapefile("SomeWorld", shapefile) }
      let(:shapefile) { "tmp/from_shapefile_spec" }
      before do
        ShapefileHelper.generate_rectangle shapefile, 9, 9
      end

      it "should generate the region with geometry and threejs" do
        region = world.regions.first
        bb = region.generate_bounding_box
        bb.min_y.should == 0
        bb.min_x.should == 0
        bb.max_y.should == 9
        bb.max_x.should == 9

        region.should be_valid
        region.geometry.should be

        world.should be_valid
      end
    end

    describe "square with hole from uDig" do
      let(:world) { Loader::World.from_shapefile("SomeWorld", shapefile) }
      let(:shapefile) { "lib/data/shapefiles/holed_square/region" }

      it "should generate geometries from the shapefile" do
        world.regions.size.should == 1
        world.name = "bogus"
        world.should be_valid
      end
    end

    describe "new york city shape file" do
      let(:world) { Loader::World.from_shapefile("SomeName", shapefile, "BoroCD") }
      let(:shapefile) { "lib/data/shapefiles/nyc/region" }

      it "should generate a geometry and threejs for every borough with neighborhoods" do
        # Primarily used to test drive and debug
        world.regions.size.should == 33
        world.regions.map(&:name).should include 101
        world.regions.map(&:name).should include 317

        world.regions.map(&:threejs).compact.count.should > 30 # nearly all

        neighborhoods = world.regions.flat_map(&:neighborhoods)
        neighborhoods.count.should > Neighborhood.where(borough: "Manhattan").count

        world.name = "bogus"
        world.should be_valid
      end
    end
  end

  describe "#generate_blocks" do
    context "for generated geometry" do
      let(:world) { FactoryGirl.build(:world) }
      let(:region1) { FactoryGirl.build(:region_with_geometry) }
      let(:region2) { FactoryGirl.build(:region_with_geometry, left: 9, bottom: 9) }

      before do
        world.regions << region1
        world.regions << region2
      end

      it "should create blocks for every region" do
        Loader::World.generate_blocks(world, 1)

        region1.blocks.size.should > 0
        region1.blocks.size.should == region2.blocks.size
        world.save.should == true
        region1.should be_persisted
        region2.should be_persisted
      end

      it "should assign the regions relative coordinates" do
        Loader::World.generate_blocks(world, 1)

        region1.left.should == 1
        region1.bottom.should == 1

        region2.left.should == 10
        region2.bottom.should == 10
      end
    end
  end
end
