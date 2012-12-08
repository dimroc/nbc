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

  describe "#as_json" do
    subject { world.as_json }
    let(:world) { FactoryGirl.create(:world_with_regions) }

    it do
      should == {
        "id"=>world.id,
        "name"=>world.name,
        "slug"=>world.slug,
        :region_names=>world.regions.map(&:slug),
        :mercator_bounding_box=>{"min_x"=>0.0, "min_y"=>0.0, "max_x"=>19.0, "max_y"=>19.0}
      }
    end
  end

  describe "#contains?" do
    subject { world.contains? point }
    let(:world) { FactoryGirl.create(:world_with_regions) }

    context "with a point in the region" do
      let(:point) { Mercator::FACTORY.point(5, 5) }
      it { should be_true }
    end

    context "with a point outside the region" do
      let(:point) { Mercator::FACTORY.point(-10000, -10000) }
      it { should be_false }
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
