require 'spec_helper'

describe Loader::World do
  describe ".from_shapefile" do
    describe "generated square" do
      let(:world) { Loader::World.from_shapefile(shapefile) }
      let(:shapefile) { "tmp/from_shapefile_spec" }
      before do
        ShapefileHelper.generate_rectangle shapefile, 9, 9
      end

      it "should generate the region with the geometry" do
        region = world.regions.first
        bb = region.generate_bounding_box
        bb.min_y.should == 0
        bb.min_x.should == 0
        bb.max_y.should == 9
        bb.max_x.should == 9

        region.should be_valid
        world.name = "bogus"
        world.should be_valid
      end
    end

    describe "square with hole from uDig" do
      let(:world) { Loader::World.from_shapefile(shapefile) }
      let(:shapefile) { "lib/data/shapefiles/holed_square/region" }

      it "should generate geometries from the shapefile" do
        world.regions.size.should == 1
        world.name = "bogus"
        world.should be_valid
      end
    end

    describe "new york city shape file" do
      let(:world) { Loader::World.from_shapefile(shapefile, "BoroCD" => "name") }
      let(:shapefile) { "lib/data/shapefiles/nyc/region" }

      it "should generate a geometry for every borough" do
        # Primarily used to test drive and debug
        world.regions.size.should == 33
        world.regions.map(&:name).should include 101
        world.regions.map(&:name).should include 317

        world.name = "bogus"
        world.should be_valid
      end
    end
  end
end
