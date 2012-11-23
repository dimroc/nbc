require 'spec_helper'

describe BlocksController do
  describe "#index" do
    context "without a world" do
      it "should fail" do
        expect { get :index }.to raise_error
      end
    end
  end
end
