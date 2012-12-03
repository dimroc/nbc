require 'spec_helper'

describe PandaVideo do
  use_vcr_cassette

  describe "validations" do
    it { should validate_uniqueness_of :panda_id }
  end

  describe ".encoded" do
    subject { PandaVideo.encoded }
    let(:included_video) { FactoryGirl.create(:video, url: "something") }

    before do
      PandaVideo.destroy_all
      FactoryGirl.create(:video, url: nil)
    end

    it { should == [included_video] }
  end

  describe ".find_or_create_from_panda" do
    subject { PandaVideo.find_or_create_from_panda("81292d1d14b508c23ae93dc98ccee543") }

    it "should create a video with proper attributes" do
      subject.attributes.should include({
        "panda_id"=>"81292d1d14b508c23ae93dc98ccee543",
        "encoding_id"=>"0e4a9657c751e95cd6acfe2e89fd4d2b",
        "original_filename"=>"SanDiegoArrival.mp4",
        "width"=>640,
        "height"=>480,
        "duration"=>7405,
        "screenshot"=>"http://newblockcity.s3.amazonaws.com/0e4a9657c751e95cd6acfe2e89fd4d2b_1.jpg",
        "url"=>"http://newblockcity.s3.amazonaws.com/0e4a9657c751e95cd6acfe2e89fd4d2b.mp4"
      })
    end
  end

  describe "#refresh_from_panda!" do
    subject { video.refresh_from_panda! }
    let(:video) do
      FactoryGirl.create(:video,
                         panda_id: '349c31e332c304f1c24086a56982dc91',
                         screenshot: nil,
                         url: nil)
    end

    it "should update the url and screenshot" do
      subject
      video.screenshot.should_not be_nil
      video.url.should_not be_nil
    end
  end
end
