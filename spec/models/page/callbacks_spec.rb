require 'spec_helper'

describe Page, 'callbacks' do

  describe "after destroying" do
    subject { Factory(:page) }

    it "destroys it's contents" do
      contents = (1..2).map { Factory(:content, :page => subject) }
      subject.destroy
      contents.each do |c|
        lambda { c.reload }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it "does not destroy any other contents" do
      contents = (1..2).map { Factory(:content) }
      subject.destroy
      contents.each do |c|
        lambda { c.reload }.should_not raise_error
      end
    end

    # these specs are for the :rootify orphan_strategy
    # it "rootifies it's children" do
    #   children = (1..2).map { Factory(:sub_page, :parent => subject) }
    #   Page.count.should eq(3)
    #   subject.destroy
    #   Page.count.should eq(2)
    #   children.each { |p| p.reload.should be_is_root }
    # end
    #
    # it "does not rootify descendants beyond it's children" do
    #   child = Factory(:sub_page, :parent => subject)
    #   grandchildren = (1..2).map { Factory(:sub_page, :parent => child) }
    #   Page.count.should eq(4)
    #   subject.destroy
    #   Page.count.should eq(3)
    #   grandchildren.each { |p| p.reload.parent.should eq(child) }
    # end
  end

end