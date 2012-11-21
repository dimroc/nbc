require 'spec_helper'

describe Region do
  describe "factories" do
    context ".region" do
      subject { FactoryGirl.build(:region) }
      it { should be_valid }
    end

    context ".region_with_geometry" do
      subject { FactoryGirl.build(:region_with_geometry, height: 5, width: 5) }
      it { should be_valid }
    end
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :slug }
    it { should validate_presence_of :left }
    it { should validate_presence_of :bottom }
  end

  describe "#as_json" do
    subject { Hashie::Mash.new region.as_json }

    let(:region) { FactoryGirl.build(:region_with_geometry) }

    its(:geometry) { should be_nil }

    context "with threejs generated" do
      before { Loader::Region.generate_threejs(region) }

      it "should have threejs entries" do
        subject[:threejs][:model].should be
        subject[:threejs][:outlines].should == [[
          0.0, 0.0,
          0.0, 9.0,
          9.0, 9.0,
          9.0, 0.0,
          0.0, 0.0
        ]]
      end
    end

    context "with blocks generated" do
      before { Loader::Region.generate_blocks(region, 1) }
      it "should include blocks" do
        subject[:blocks].should have(64).items
      end

      it "should only render relevant block information" do
        subject[:blocks][0][:created_at].should be_nil
        subject[:blocks][0][:updated_at].should be_nil
        subject[:blocks][0][:point].should be_nil
      end
    end

    context "with neighborhoods" do
      it "should only render the neighborhood name" do
        subject[:neighborhoods][0][:name].should == Neighborhood.first.name
        subject[:neighborhoods][0][:borough].should be_nil
      end
    end
  end

  describe "#generate_bounding_box" do
    let(:region) { FactoryGirl.build(:region_with_geometry) }
    let(:expected_bb) do
      Cartesian::BoundingBox.create_from_geometry(region.geometry)
    end

    it "should generate the bounding box" do
      region.generate_bounding_box.should == expected_bb
    end
  end

  describe "#simplify_geometry" do
    let(:nyc) { worlds(:nyc) }
    let(:region) { nyc.regions.first }

    it "should have less than 10 vertices" do
      region.simplify_geometry.first.exterior_ring.num_points.should < 30
    end
  end
end
