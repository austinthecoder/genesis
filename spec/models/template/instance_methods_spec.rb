require 'spec_helper'

describe Template, 'instance methods' do

  subject { Factory.build(:template) }

  describe "#destroy" do
    context "with pages" do
      before do
        subject.save!
        Factory(:page, :template => subject)
      end

      it "should not be destroyed" do
        subject.destroy
        subject.should_not be_destroyed
      end
      its(:destroy) { should be_false }
    end

    context "without pages" do
      it "should be destroyed" do
        subject.destroy_without_page_checking
        subject.should be_destroyed
      end
      its(:destroy) { should eq(subject) }
    end
  end

  describe "#destroy_without_page_checking" do
    [
      ["with pages", lambda { |tpl| Factory(:page, :template => tpl) }],
      ["without pages", lambda { |tpl| }]
    ].each do |cntxt, proc|
      context cntxt do
        before do
          subject.save!
          proc.call(subject)
        end

        it "should be destroyed" do
          subject.destroy_without_page_checking
          subject.should be_destroyed
        end
        its(:destroy) { should eq(subject) }
      end
    end
  end

  describe "#destroy!" do
    context "when destroy fails" do
      before { subject.stub(:destroy) { false } }
      it { lambda { subject.destroy! }.should raise_error }
    end

    context "when destroy doesn't fail" do
      before { subject.stub(:destroy) { true } }
      it { lambda { subject.destroy! }.should_not raise_error }
    end
  end

end