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
            (0..height).each do |top|
              region.blocks.any? { |block| block.left == left && block.top == top }
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
end
