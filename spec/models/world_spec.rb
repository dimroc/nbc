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
