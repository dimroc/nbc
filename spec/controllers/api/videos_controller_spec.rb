require 'spec_helper'

describe Api::VideosController do
  use_vcr_cassette

  describe ".create" do
    let(:params) do
      { "panda_video_id" => "81292d1d14b508c23ae93dc98ccee543" }
    end

    it "should create a video entry" do
      expect {
        post :create, params
      }.to change { Video.count }.by(1)

      video = Video.last
      video.panda_id.should == "81292d1d14b508c23ae93dc98ccee543"
      video.url.should be
      video.screenshot.should be
    end
  end
end
