require 'spec_helper'

describe WorldsController do
  let(:nyc) { worlds(:nyc) }

  describe ".index" do
    before { get :index }

    it "should return a list of worlds", jasmine_fixture: true do
      response.status.should == 200
      world_json = JSON.parse response.body
      world_json.count.should == World.count
      world_json[0].should equal_json_of nyc

      save_fixture(response.body, "worlds")
    end
  end

  describe ".show" do
    subject { JSON.parse response.body }
    before { get :show, id: nyc.id }

    it "should return nyc's regions", jasmine_fixture: true do
      response.status.should == 200
      subject.should equal_json_of nyc
      save_fixture response.body, "nyc"
    end
  end
end
