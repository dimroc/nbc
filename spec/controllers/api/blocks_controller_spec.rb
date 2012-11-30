require 'spec_helper'

describe Api::BlocksController do
  use_vcr_cassette

  describe "#create" do
    let(:params) do
      { "longitude" => -73.98469, "latitude" => 40.7297, "video_id" => video.id }
    end

    context "with video id" do
      let(:video) { FactoryGirl.create(:video) }

      it "should create a block for that location" do
        expect {
          post :create, params
        }.to change { Block::Video.count }.by(1)

        block_hash = JSON.parse(response.body)
      end
    end

    context "with panda id" do
      it "should create a video and a block" do
        pending

      end
    end
  end
end
