require 'spec_helper'

describe Client::BlocksController do
  describe ".create" do

    context "without client api token" do
      it "should not throw an error" do
        post :create, {}

        response.should be_forbidden
        response.body.should have_content "do not have access"
      end
    end

    context "with client api token" do
      before { request.env['NBC_SIGNATURE'] = 'yicceHasFatcowJemIvRurwojidfaitt' }

      it "should create a block"
    end
  end
end
