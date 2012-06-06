require 'spec_helper'

describe Ability do
  subject { Ability.new(user) }
  describe "User" do
    let(:user) { FactoryGirl.create(:user) }
    it { should be_able_to(:manage, Block.new) }
  end
end
