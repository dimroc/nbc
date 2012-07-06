require 'spec_helper'

describe BlocksController do
  context ".index" do
    let(:nyc) { regions(:nyc) }

    context "with region id" do
      it "should return the associated blocks", jasmine_fixture: true do
        get :index, { region_id: nyc.id }
        blocks_hash = JSON.parse(response.body)
        blocks_hash.each do |returned_block|
          Block.exists?(returned_block["id"]).should be_true
          returned_block["region_id"].should == nyc.id
        end

        save_fixture(response.body, "nyc_blocks")
      end
    end

    context "without region id" do
      it "should raise an error" do
        expect { get :index }.to raise_error ActionController::RoutingError
      end
    end
  end
end
