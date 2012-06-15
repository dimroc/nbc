require 'spec_helper'

describe RegionsController do
  describe ".index" do
    let(:nyc) { regions(:nyc) }

    it "should return all regions in json" do
      get :index
      regions_json = JSON.parse response.body
      regions_json.count.should == Region.count
      regions_json[0].should equal_json_of nyc
    end
  end

  describe ".create" do
    let(:region) { Region.new(name: "NewRegion") }
    let(:params) { {region: region.attributes } }
    before { post :create, params }
    subject { JSON.parse response.body }

    it { should equal_json_of Region.last }
  end

  describe ".update" do
    let(:nyc) { regions(:nyc) }
    let(:params) { { region: nyc.attributes } }

    it "should update the region" do
      nyc.name = "New and Improved York City"
      post :update, params.merge(id: nyc.id)
      region_json = JSON.parse response.body
      region_json.should equal_json_of nyc
    end
  end

  describe ".show" do
    subject { JSON.parse response.body }
    let(:nyc) { regions(:nyc) }
    before { get :show, id: nyc.id }
    it { should equal_json_of nyc }
  end

  describe ".destroy" do
    let(:nyc) { regions(:nyc) }
    before { post :destroy, id: nyc.id }
    it "should destroy the region" do
      Region.exists?(nyc.id).should be_false
      JSON.parse(response.body).should equal_json_of nyc
    end
  end
end
