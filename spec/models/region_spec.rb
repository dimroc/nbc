require 'spec_helper'

describe Region do
  describe "factories" do
    context ".region" do
      subject { FactoryGirl.build(:region) }
      it { should be_valid }
    end

    context ".region_with_geometry" do
      subject { FactoryGirl.build(:region_with_geometry, height: 5, width: 5) }
      it { should be_valid }
    end
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :slug }
  end

  describe "#generate_blocks" do
    let(:region) { FactoryGirl.build(:region_with_geometry, width: width, height: height) }
    let(:width) { 9 }
    let(:height) { 9 }

    it "should generate blocks within the geometry" do
      # Minus 1 from the boundaries because the generated
      # blocks must be WITHIN the geometry
      expected_count = (width-1) * (height-1)

      region.generate_blocks(1)
      expect { region.save }.to change { Region.count }.by(1)

      region.blocks.count.should == expected_count

      (1...width).each do |left|
        (1...height).each do |bottom|
          region.blocks.any? do |block|
            block.left == left && block.bottom == bottom &&
              block.point == Cartesian::preferred_factory().point(left, bottom)
          end.should be_true
        end
      end
    end
  end

  describe "#generate_bounding_box" do
    let(:region) { FactoryGirl.build(:region_with_geometry) }
    let(:expected_bb) do
      Cartesian::BoundingBox.create_from_geometry(region.geometry)
    end

    it "should generate the bounding box" do
      region.generated_bounding_box.should == expected_bb
    end
  end
end

