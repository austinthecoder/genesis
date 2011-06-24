require 'spec_helper'

describe Page::Drop do

  subject { Page::Drop.new(@page) }

  describe ".new" do
    context "with a Page instance" do
      before { @page = Factory(:page) }
      it { lambda { subject }.should_not raise_error }
    end

    context "with a non-Page instance" do
      [nil, "x"].each do |arg|
        before { @page = arg }
        it "raises an error" do
          lambda { subject }.should raise_error(ArgumentError, "#{@page.inspect} must be a Page")
        end
      end
    end
  end

  describe "instance methods" do
    before do
      @page = Factory(:page, :title => 'My Awesome Page')
      content = Factory(:content,
        :page => @page,
        :field => Factory(:field, :template => @page.template, :name => 'Body'),
        :body => "I love soccer."
      )
    end

    it { should be_a(Liquid::Drop) }
    it { should be_a(Comparable) }
    its(:page) { should eq(@page) }

    describe "#invoke_drop" do
      it { subject.invoke_drop('Title').should eq("My Awesome Page") }

      context "when the method is the name of a page field" do
        it { subject.invoke_drop('Body').should == "I love soccer." }
      end

      context "when the method is not the name of a page field" do
        [nil, "foo", "body"].each do |method|
          it { subject.invoke_drop(method).should be_nil }
        end
      end
    end

    describe "<=>" do
      context "when the other page drop was instantiated with the same page" do
        before { @other_page_drop = Page::Drop.new(Page.find(@page.id)) }
        it { subject.is_a?(Comparable); (subject <=> @other_page_drop).should == 0 }
      end
    end
  end

end