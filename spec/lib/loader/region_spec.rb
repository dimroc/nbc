require 'spec_helper'

describe Loader::Region do
  describe "#generate_blocks" do
    let(:region) { FactoryGirl.build(:region_with_geometry, width: width, height: height) }
    let(:width) { 9 }
    let(:height) { 9 }

    it "should generate blocks within the geometry" do
      # Minus 1 from the boundaries because the generated
      # blocks must be WITHIN the geometry
      expected_count = (width-1) * (height-1)

      Loader::Region.generate_blocks(region, 1)
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
end
