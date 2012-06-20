require 'spec_helper'

describe Region do
  describe "factories" do
    it "should build a valid region" do
      FactoryGirl.build(:region).should be_valid
    end
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :slug }
  end
end
