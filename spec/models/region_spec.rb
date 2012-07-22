require 'spec_helper'

describe Region do
  describe "factories" do
    context ".region" do
      shared_examples_for "a valid region" do
        it "should generate the region" do
          expected_count = width * height
          expect { region.save }.to change { Region.count }.by(1)
          region.blocks.count.should == expected_count

          (0..width).each do |left|
            (0..height).each do |bottom|
              region.blocks.any? { |block| block.left == left && block.bottom == bottom }
            end
          end
        end
      end

      context "with default values" do
        let(:region) { FactoryGirl.build(:region) }
        let(:width) { 10 }
        let(:height) { 10 }
        it_should_behave_like "a valid region"
      end

      context "with set values" do
        let(:region) { FactoryGirl.build(:region, name: region_name, width: width, height: height) }
        let(:region_name) { "New York City" }
        let(:width) { 19 }
        let(:height) { 7 }

        it "should assign the name" do
          region.name.should == region_name
        end

        it_should_behave_like "a valid region"
      end
    end
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :slug }
  end

  describe ".from_shapefile" do
    describe "generated square" do
      let(:shapefile) { "tmp/from_shapefile_spec" }
      let(:block_length) { 1 }

      before do
        ShapefileHelper.generate_rectangle shapefile, 9, 9
      end

      it "should generate the region with the appropriate blocks" do
        region = Region.from_shapefile("bogus", shapefile, block_length)
        region.blocks.size.should == 64
        region.bounding_box.should ==
          Cartesian::BoundingBox.create_from_points(
            Cartesian::preferred_factory().point(0, 0),
            Cartesian::preferred_factory().point(9, 9))
        region.should be_valid
      end
    end

    describe "square with hole from uDig" do
      let(:shapefile) { "spec/fixtures/holed_square/holed_square" }
      let(:block_length) { 1 }

      it "should only generate squares that are in the geometry" do
        region = Region.from_shapefile("bogus", shapefile, block_length)
        region.blocks.size.should_not == region.bounding_box.steps(block_length)
        region.should be_valid
      end
    end
  end
end
