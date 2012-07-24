require 'spec_helper'

describe RegionsController do
  describe ".index" do
    shared_examples_for "a region index action" do
      it "should return all regions in json", jasmine_fixture: true do
        get :index, world_id: world.id
        regions_json = JSON.parse response.body
        regions_json.count.should == world.regions.count
        regions_json.should equal_json_of world.regions

        save_fixture(response.body, world.slug)
      end
    end

    describe "for nyc" do
      it_should_behave_like "a region index action" do
        let(:world) { worlds(:nyc) }
      end
    end

    describe "for miami" do
      it_should_behave_like "a region index action" do
        let(:world) { worlds(:miami) }
      end
    end
  end
end
