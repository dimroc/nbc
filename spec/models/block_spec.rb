require 'spec_helper'

describe Block do
  describe "validations" do
    it { should validate_presence_of :left }
    it { should validate_presence_of :bottom }
  end

  describe ".near" do
    subject { Block.near(near_point) }

    before { Block.delete_all }

    let(:near_point) { Mercator::FACTORY.projection_factory.point(5,5) }
    let(:far_point) { Mercator::FACTORY.projection_factory.point(25,25) }

    let!(:near_block) { Block.create(point: near_point, left: 0, bottom: 0) }
    let!(:far_block) { Block.create(point: far_point, left: 5, bottom: 5) }

    it { should == [near_block, far_block] }
  end
end
