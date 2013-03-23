require 'spec_helper'

describe PusherObserver do
  before(:each) { enable_observer(:pusher_observer) }

  describe 'after block creation' do
    context "with Pusher initialized" do
      # Class var assignments live past the test, so clean up.
      before { Pusher.app_id = Pusher.secret = Pusher.key = 'garbage' }
      after { Pusher.app_id = Pusher.secret = Pusher.key = nil }

      it "should broadcast a pusher event" do
        block = FactoryGirl.build(:block)
        Pusher.should_receive(:trigger).with(
          'global',
          'block',
          block.as_json)
        PusherObserver.instance.after_create block
      end
    end

    context "with Pusher NOT initialized" do
      it "should NOT broadcast a pusher event" do
        Pusher.should_not_receive(:trigger)
        FactoryGirl.create(:block)
      end
    end
  end
end
