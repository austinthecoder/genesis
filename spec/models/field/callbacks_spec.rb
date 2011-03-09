require 'spec_helper'

describe Field, 'callbacks' do

  describe "after creating" do
    subject { Factory.build(:field) }

    context "when it's template has pages" do
      before do
        @pages = (1..2).map do |i|
          Factory(:page, :template => subject.template)
        end
      end

      it "creates contents" do
        Content.count.should eq(0)
        subject.save!
        @pages.each do |p|
          Content.where(:page_id => p.id, :field_id => subject.id).size.should eq(1)
        end
        Content.count.should eq(@pages.size)
      end
    end

    context "when it's template does not have any pages" do
      it "does not create any contents" do
        subject.save!
        Content.count.should eq(0)
      end
    end
  end

end