require 'spec_helper'

describe Neighborhood do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :borough }
    it { should validate_presence_of :point }
  end

  describe "in_geometry" do
    subject { Neighborhood.in_geometry(geometry) }

    context "integration" do
      let(:included_neighborhood) { Neighborhood.first }
      let(:geometry) { included_neighborhood.point }

      it "should return the relevant neighborhoods" do
        subject.should == [included_neighborhood]
      end
    end
  end
end
