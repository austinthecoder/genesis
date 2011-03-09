require 'spec_helper'

describe Content, 'validations' do

  context "with valid attributes" do
    subject { Factory.build(:content) }

    it { should be_valid }
    it { should_not accept_values_for(:field_id, nil) }
    it { should_not accept_values_for(:page_id, nil) }

    context "when content exists with page_id 5 and field_id 7" do
      before { Factory(:content, :page_id => 5, :field_id => 7) }

      context "when the page_id is 5" do
        before { subject.page_id = 5 }

        it { should_not accept_values_for(:field_id, 7) }
        it { should accept_values_for(:field_id, 5, 6) }
      end
    end
  end

end