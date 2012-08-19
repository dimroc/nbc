require 'spec_helper'

describe World do
  describe "factories" do
    describe "#world" do
      subject { FactoryGirl.build(:world) }
      it { should be_valid }
    end

    describe "#world_with_regions" do
      subject { FactoryGirl.build(:world_with_regions) }
      it { should be_valid }
    end
  end

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
        region.generated_bounding_box.should ==
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
        world.generate_blocks(1)

        region1.blocks.size.should > 0
        region1.blocks.size.should == region2.blocks.size
        world.save.should == true
        region1.should be_persisted
        region2.should be_persisted
      end

      it "should assign the regions relative coordinates" do
        world.generate_blocks(1)

        region1.left.should == 0
        region1.bottom.should == 0

        region2.left.should == 9
        region2.bottom.should == 9
      end
    end
  end

  describe "#generated_bounding_box" do
    subject { world.generated_bounding_box }

    context "with regions that have geometry" do
      let(:world) { FactoryGirl.create(:world_with_regions) }
      it "should generate a bounding box encompassing all regions" do
        world.regions.each do |region|
          subject.contains? region.generated_bounding_box
        end
      end
    end

    context "with regions that don't have geometry" do
      let(:world) { FactoryGirl.create(:world) }
      before { FactoryGirl.create(:region, world: world); world.reload }
      it { should be_empty }
    end

    context "with no regions" do
      let(:world) { FactoryGirl.create(:world) }
      it { should be_empty }
    end
  end
end