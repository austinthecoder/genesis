require 'spec_helper'

describe Page, 'callbacks' do

  describe "after saving" do
    before do
      @tpl = Factory(:template)
      @page = Factory(:page, :template => @tpl)
      2.times { Factory(:field, :template => @tpl) }
      @page.reload
    end

    context "if the template_id changed" do
      before do
        @new_tpl = Factory(:template)
        @fields = (1..2).map { Factory(:field, :template => @new_tpl) }
        @page.template = @new_tpl
      end

      it "destroys it's previous contents" do
        previous_contents = @page.contents.all
        previous_contents.size.should eq(2)
        @page.save!
        previous_contents.each do |c|
          lambda { c.reload }.should raise_error(ActiveRecord::RecordNotFound)
        end
      end

      it "creates contents for it's fields" do
        @page.save!
        @fields.each do |f|
          Content.where(:page_id => @page.id, :field_id => f.id).size.should eq(1)
        end
      end
    end

    context "if the template_id did not change" do
      it "does not create or destroy any content" do
        contents = Content.all
        contents.size.should eq(2)
        @page.save!
        Content.all.should eq(contents)
      end
    end
  end

##################################################

  describe "after destroying" do
    subject { Factory(:page) }

    context "with contents" do
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

    it "rootifies it's children" do
      children = (1..2).map { Factory(:sub_page, :parent => subject) }
      Page.count.should eq(3)
      subject.destroy
      Page.count.should eq(2)
      children.each { |p| p.reload.should be_is_root }
    end

    it "does not rootify descendants beyond it's children" do
      child = Factory(:sub_page, :parent => subject)
      grandchildren = (1..2).map { Factory(:sub_page, :parent => child) }
      Page.count.should eq(4)
      subject.destroy
      Page.count.should eq(3)
      grandchildren.each { |p| p.reload.parent.should eq(child) }
    end
  end

end