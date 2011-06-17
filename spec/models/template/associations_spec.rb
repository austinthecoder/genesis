require 'spec_helper'

describe Template, "associations" do
  describe "fields" do
    let(:template) { Factory(:template) }
    subject { template.fields }

    describe "#add!" do
      context "with valid attributes" do
        field_attrs = {:name => 'name45798', :field_type => 'short_text'}

        it "creates a field" do
          lambda { subject.add!(field_attrs) }.should change { Field.count }.by(1)
        end

        describe "the created field" do
          before do
            subject.add!(field_attrs)
            @field = Field.last
          end

          field_attrs.each do |name, value|
            it { @field.send(name).should == value }
          end
        end

        context "when the field's template has pages" do
          before { @pages = (1..2).map { Factory(:page, :template => template) } }

          it "creates content for the field and pages" do
            subject.add!(field_attrs)
            field = Field.last
            @pages.each do |p|
              Content.where(:page_id => p, :field_id => field.id).size.should == 1
            end
          end

          it "doesn't create any other content" do
            lambda { subject.add!(field_attrs) }.should change { Content.count }.by(2)
          end
        end

        context "when the field's template doesn't have pages" do
          it "doesn't create content" do
            lambda { subject.add!(field_attrs) }.should_not change { Content.count }
          end
        end
      end

      context "with invalid attributes" do
        it "doesn't create a field" do
          lambda { subject.add! }.should raise_error(ActiveRecord::RecordInvalid)
        end

        it "doesn't create content" do
          lambda { subject.add! rescue nil }.should_not change { Content.count }
        end
      end
    end
  end
end