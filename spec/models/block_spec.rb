require 'spec_helper'

describe Block do
  describe ".near" do
    subject { Block.near(near_point) }

    before { Block.delete_all }

    let(:near_point) { Mercator::FACTORY.projection_factory.point(5,5) }
    let(:far_point) { Mercator::FACTORY.projection_factory.point(25,25) }

    let!(:near_block) { Block.create(point: near_point) }
    let!(:far_block) { Block.create(point: far_point) }

    it { should == [near_block, far_block] }
  end
end
