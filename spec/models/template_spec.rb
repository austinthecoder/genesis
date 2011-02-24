require 'spec_helper'

describe Template do

  subject { Template.new }

  describe "#user" do
    context "when a user exists with the id 234" do
      before { @u = Factory(:user, :id => 234) }

      context "when the user_id is set to that id" do
        before { subject.user_id = 234 }

        it { subject.user.should == @u }
      end
    end
  end

end