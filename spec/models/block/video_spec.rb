require 'spec_helper'

describe Block::Video do
  describe "#as_json" do
    subject { block_video.as_json }
    let(:block_video) { FactoryGirl.create(:block_video) }

    it "should include the video details" do
      video = block_video.video
      subject.should include({ "video" =>
                               {
                                 "url" => video.url,
                                 "screenshot" => video.screenshot,
                                 "duration" => video.duration
                                }
      })
    end
  end
end
