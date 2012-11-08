require 'spec_helper'

describe BlocksController do
  describe "#index" do
    context "with a world" do
      let!(:nyc) { worlds(:nyc) }
      before { nyc.blocks.count.should > 0 }

      it "should return the world's blocks" do
        get :index, world_id: nyc.id
        response.should be_success

        blocks = JSON.parse response.body
        blocks.count.should == nyc.blocks.count
        Region.find(blocks[0]["region_id"]).world.should == nyc

        blocks.should equal_json_of nyc.blocks
      end

      context "with latitude and longitude" do
        let(:my_block) { nyc.blocks.first }
        let(:params) do
          {
            world_id: nyc.id,
            longitude: my_block.point_geographic.longitude,
            latitude: my_block.point_geographic.latitude
          }
        end

        it "should return the block at that position" do
          get :index, params
          response.should be_success

          blocks = JSON.parse response.body
          blocks.count.should == 1
          blocks.should equal_json_of [my_block]
        end
      end
    end

    context "without a world" do
      it "should fail" do
        expect { get :index }.to raise_error
      end
    end
  end
end
