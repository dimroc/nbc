require 'spec_helper'

describe THREEJS::Encoder do
  describe ".from_geometry" do
    context "integration" do
      let(:geometry) { worlds(:nyc).regions.first.geometry }

      context "when a point is repeated" do
        it "should generate a THREE JS model format hash" do
          as_json = THREEJS::Encoder.from_geometry geometry
          to_json = as_json.to_json
        end
      end
    end

    context "square" do
      let(:geometry) { FactoryGirl.create(:region_with_geometry).geometry }

      it "should generate a THREE JS model format hash" do
        as_json = THREEJS::Encoder.from_geometry geometry
        as_json[:vertices].count.should == 6 * 3 # 6 3D points
        as_json[:faces].should == [
          0, 0, 1, 2, # First triangle face
          0, 3, 4, 5  # Second triangle face
        ]
      end
    end
  end
end
