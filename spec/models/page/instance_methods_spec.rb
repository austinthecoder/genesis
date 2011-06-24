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

    context "when persisted" do
      before { subject.save! }

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

  describe "to_html" do
    before do
      @parse_args = "some content"
      @render_args = {'page' => Page::Drop.new(subject)}
      subject.template.content = @parse_args
      @parsed_content = Liquid::Template.parse(@parse_args)
      @rendered_content = @parsed_content.render(@render_args)
      @parsed_content.stub(:render) { @rendered_content }
      Liquid::Template.stub(:parse) { @parsed_content }
    end

    it "parses the template's content" do
      Liquid::Template.should_receive(:parse).with(@parse_args)
      subject.to_html
    end

    it "renders the parsed content" do
      @parsed_content.should_receive(:render).with('page' => Page::Drop.new(subject))
      subject.to_html
    end

    it "returns the rendered content" do
      subject.to_html.should == @rendered_content
    end
  end
end