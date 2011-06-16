require 'spec_helper'

describe Page, "instance methods" do

  subject { Factory.build(:page) }

  describe "#slug_editable?" do
    context "when it is root" do
      it { should_not be_slug_editable }
    end

    context "when it is not root" do
      before { subject.update_attributes!(:parent => Factory(:page), :slug => 'myslug') }

      it { should be_slug_editable }
    end
  end

  describe "#can_destroy?" do
    context "when it is a new record" do
      it { should be_can_destroy }
    end

    context "when it is not a new record" do
      before { subject.save! }

      context "when it is childless" do
        it { should be_can_destroy }
      end

      context "when it has children" do
        before do
          Factory(:sub_page, :parent => subject)
        end

        it { should_not be_can_destroy }
      end
    end
  end

  describe "#destroy" do
    context "when cannot destroy" do
      before do
        subject.save!
        Factory(:sub_page, :parent => subject)
      end

      it { lambda { subject.destroy }.should raise_error(Ancestry::AncestryException) }
    end
  end

end