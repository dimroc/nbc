require 'spec_helper'

describe RegionsController do
  describe ".index" do
    describe "for nyc" do
      let(:world) { worlds(:nyc) }
      it "should return all regions in json", jasmine_fixture: true do
        get :index, world_id: world.id
        regions_json = JSON.parse response.body
        regions_json.count.should == world.regions.count
        regions_json.should equal_json_of world.regions

        save_fixture(response.body, world.slug)
      end
    end
  end
end
