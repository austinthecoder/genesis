require 'spec_helper'

describe Page, 'callbacks' do

  describe "after creating" do
    subject { Factory.build(:page) }

    context "when it has fields" do
      before do
        tpl = Factory(:template)
        subject.template = tpl
        @fields = (1..2).map { |i| Factory(:field, :template => tpl) }
      end

      it "creates contents for those fields" do
        Content.count.should eq(0)
        subject.save!
        @fields.each do |f|
          Content.where(:page_id => subject.id, :field_id => f.id).size.should eq(1)
        end
        Content.count.should eq(@fields.size)
      end
    end

    context "when it does not have fields" do
      it "does not create any contents" do
        subject.save!
        Content.count.should eq(0)
      end
    end
  end

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