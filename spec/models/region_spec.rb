require 'spec_helper'

describe Region do
  describe "factories" do
    context ".region" do
      context "with default values" do
        subject { FactoryGirl.build(:region) }
        it { should be_valid }
      end
    end
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :slug }
  end

  describe "#bounding_box" do
    let(:region) { FactoryGirl.build(:region_with_geometry) }
    it "should return the correct bounding box" do
      region.bounding_box.should ==
        Cartesian::BoundingBox.create_from_geometry(region.geometry)
    end
  end
end
