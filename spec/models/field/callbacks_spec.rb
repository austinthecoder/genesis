require 'spec_helper'

describe Field, 'callbacks' do

  describe "after destroying" do
    subject { Factory(:field) }

    before do
      @contents = []
      2.times { @contents << Factory(:content) }
      2.times { @contents << Factory(:content, :field => subject) }
    end

    it "does not destroy any content" do
      subject.destroy
      @contents.each do |c|
        lambda { c.reload }.should_not raise_error
      end
    end
  end

end