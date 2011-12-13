require 'spec_helper'

describe Page, 'fields' do
  subject { @page.fields }

  before { @page = Factory(:page) }

  describe "#create_contents!" do
    [1, 2].each do |nbr_fields|
      context "with #{nbr_fields} fields" do
        before { nbr_fields.times { Factory(:field, :template => @page.template) } }

        it "should create content for each field" do
          lambda { subject.create_contents! }.should change { Content.count }.by(nbr_fields)
        end

        describe "the created contents" do
          let(:contents) { Content.order('id DESC').limit(nbr_fields) }
          before { subject.create_contents! }

          it "all belong to the page" do
            contents.all? { |c| c.page == @page }.should be_true
          end

          it "belongs to each field" do
            subject.all.each do |field|
              contents.detect { |c| c.field == field }.should be_true
            end
          end
        end
      end
    end

    context "without fields" do
      it "doesn't create any content" do
        lambda { subject.create_contents! }.should_not change { Content.count }
      end
    end
  end
end