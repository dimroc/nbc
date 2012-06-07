require 'spec_helper'

describe Block do
  describe "validations" do
    it { should validate_presence_of :left }
    it { should validate_presence_of :top }
  end
end
