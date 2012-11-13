require 'spec_helper'

describe Neighborhood do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :borough }
    it { should validate_presence_of :point }
  end

  describe "for_region" do
    subject { Neighborhood.for_region(region) }

    context "integration" do
      let(:included_neighborhood) { Neighborhood.first }
      let(:region) { Region.create(name: "SomePoint", geometry: included_neighborhood.point) }

      it "should return the relevant neighborhoods" do
        subject.should == [included_neighborhood]
      end
    end
  end
end
