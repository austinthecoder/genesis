require 'spec_helper'

describe Page do

  subject { Factory.build(:page) }

  describe "slug_editable?" do
    context "when it is root" do
      it { should_not be_slug_editable }
    end

    context "when it is not root" do
      before { subject.update_attributes!(:parent => Factory(:page)) }

      it { should be_slug_editable }
    end
  end

end