require 'spec_helper'

describe Page, 'contents' do
  subject { @page.contents }

  before { @page = Factory(:page) }

  describe "#active" do
    it "returns the contents that have a field and a template" do
      contents = (1..3).map { Factory(:content, :page => @page) }
      field = Factory.build(:field, :template => nil)
      field.save!(:validate => false)
      content = Factory.build(:content, :page => @page, :field => nil)
      content.save!(:validate => false)
      contents += [
        content,
        Factory(:content, :page => @page, :field => field),
        Factory(:content)
      ]
      subject.active.should == contents[0..2]
    end
  end
end