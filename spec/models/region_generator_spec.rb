require 'spec_helper'

describe RegionGenerator do
  describe ".generate" do
    let(:region) { RegionGenerator.generate(region_name, width, height) }
    let(:region_name) { "New York City" }

    context "and width" do
      let(:width) { 5 }

      context "and height" do
        let(:height) { 7 }

        it "should generate the appropriate blocks" do
          expected_count = (width + 1) * (height + 1)
          expect { region }.to change { Region.count }.by(1)
          region.blocks.count.should == expected_count

          (0..width).each do |left|
            (0..height).each do |top|
              region.blocks.any? { |block| block.left == left && block.top == top }
            end
          end
        end
      end
    end
  end
end
