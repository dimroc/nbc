require 'spec_helper'

describe RGeo::Cartesian::BoundingBox do
  let(:bb) do
    Cartesian::BoundingBox.create_from_points(
      Cartesian::preferred_factory().point(0,0),
      Cartesian::preferred_factory().point(9,9))
  end

  describe "#step" do
    let(:increment) { 1 }
    it "should generate yield a point for ever step" do
      steps = []
      bb.step(increment) do |point|
        steps << point
      end

      steps.count.should == 100
      (0..10).each do |x|
        (0..10).each do |y|
          steps.select { |s| s.x == x && s.y == y }.count == 1
        end
      end
    end
  end
end
