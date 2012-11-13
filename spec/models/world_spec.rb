require 'spec_helper'

describe World do
  describe "factories" do
    describe "#world" do
      subject { FactoryGirl.build(:world) }
      it { should be_valid }
    end

    describe "#world_with_regions" do
      subject { FactoryGirl.build(:world_with_regions) }
      it { should be_valid }
    end
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :slug }
  end

  describe "#regenerate_blocks" do
    context "for generated geometry" do
      let(:world) { FactoryGirl.build(:world) }
      let(:region1) { FactoryGirl.build(:region_with_geometry) }
      let(:region2) { FactoryGirl.build(:region_with_geometry, left: 9, bottom: 9) }

      before do
        world.regions << region1
        world.regions << region2
      end

      it "should create blocks for every region" do
        world.regenerate_blocks(1)

        region1.blocks.size.should > 0
        region1.blocks.size.should == region2.blocks.size
        world.save.should == true
        region1.should be_persisted
        region2.should be_persisted
      end

      it "should assign the regions relative coordinates" do
        world.regenerate_blocks(1)

        region1.left.should == 1
        region1.bottom.should == 1

        region2.left.should == 10
        region2.bottom.should == 10
      end
    end
  end

  describe "#generate_bounding_box" do
    subject { world.generate_bounding_box }

    context "with regions that have geometry" do
      let(:world) { FactoryGirl.create(:world_with_regions) }
      it "should generate a bounding box encompassing all regions" do
        world.regions.each do |region|
          subject.contains? region.generate_bounding_box
        end
      end
    end

    context "with regions that don't have geometry" do
      let(:world) { FactoryGirl.create(:world) }
      before { FactoryGirl.create(:region, world: world); world.reload }
      it { should be_empty }
    end

    context "with no regions" do
      let(:world) { FactoryGirl.create(:world) }
      it { should be_empty }
    end
  end
end
