require 'spec_helper'

describe Page, 'callbacks' do

  describe "after destroying" do
    subject { Factory(:page) }

    before do
      @non_page_contents = (1..2).map { Factory(:content) }
      @page_contents = (1..2).map { Factory(:content, :page => subject) }
    end

    it "destroys it's contents" do
      subject.destroy
      @page_contents.each do |c|
        lambda { c.reload }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it "does not destroy any other contents" do
      subject.destroy
      @non_page_contents.each do |c|
        lambda { c.reload }.should_not raise_error
      end
    end
  end

end