require 'spec_helper'

describe Field, 'callbacks' do

  # describe "after creating" do
  #   subject do
  #     @field_id = 4537934
  #     Factory.build(:field, :id => @field_id)
  #   end
  #
  #   context "when it has pages" do
  #     before do
  #       @pages = (1..2).map do |i|
  #         Factory(:page, :template => subject.template)
  #       end
  #     end
  #
  #     it "creates contents for those pages" do
  #       Content.count.should eq(0)
  #       subject.save!
  #       @pages.each do |p|
  #         Content.where(:page_id => p.id, :field_id => @field_id).size.should eq(1)
  #       end
  #       Content.count.should eq(@pages.size)
  #     end
  #
  #     context "when one of the pages already has content" do
  #       before { Content.create!(:page_id => @pages[0].id, :field_id => @field_id) }
  #
  #       it "does not create another content" do
  #         Content.count.should eq(1)
  #         subject.save!
  #         @pages.each do |p|
  #           Content.where(:page_id => p.id, :field_id => @field_id).size.should eq(1)
  #         end
  #         Content.count.should eq(@pages.size)
  #       end
  #     end
  #   end
  #
  #   context "when it does not have pages" do
  #     it "does not create any contents" do
  #       subject.save!
  #       Content.count.should eq(0)
  #     end
  #   end
  # end

  describe "after destroying" do
    subject { Factory(:field) }

    before do
      @contents = []
      2.times { @contents << Factory(:content) }
      2.times { @contents << Factory(:content, :field => subject) }
    end

    it "does not destroy any content" do
      subject.destroy
      @contents.each do |c|
        lambda { c.reload }.should_not raise_error
      end
    end
  end

end