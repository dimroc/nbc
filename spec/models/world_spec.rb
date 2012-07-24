require 'spec_helper'

describe World do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :slug }
  end

  describe ".build_from_shapefile" do
    describe "generated square" do
      let(:world) { World.build_from_shapefile(shapefile) }
      let(:shapefile) { "tmp/from_shapefile_spec" }
      before do
        ShapefileHelper.generate_rectangle shapefile, 9, 9
      end

      it "should generate the region with the geometry" do
        region = world.regions.first
        region.bounding_box.should ==
          Cartesian::BoundingBox.create_from_points(
            Cartesian::preferred_factory().point(0, 0),
            Cartesian::preferred_factory().point(9, 9))

        region.should be_valid
        world.name = "bogus"
        world.should be_valid
      end
    end

    describe "square with hole from uDig" do
      let(:world) { World.build_from_shapefile(shapefile) }
      let(:shapefile) { "lib/assets/shapefiles/holed_square/region" }

      it "should generate geometries from the shapefile" do
        world.regions.size.should == 1
        world.name = "bogus"
        world.should be_valid
      end
    end

    describe "new york city shape file" do
      let(:world) { World.build_from_shapefile(shapefile, "BoroName" => "name") }
      let(:shapefile) { "lib/assets/shapefiles/nyc/region" }

      it "should generate a geometry for every borough" do
        # Primarily used to test drive and debug
        world.regions.size.should == 5
        world.regions.map(&:name).should include "Manhattan"
        world.regions.map(&:name).should include "Brooklyn"

        world.name = "bogus"
        world.should be_valid
      end
    end
  end
end
