require 'spec_helper'

describe Field, 'validations' do

  context "with valid attributes" do
    subject { Factory.build(:field) }

    it { should be_valid }
    it { should_not accept_values_for(:name, nil, '', ' ') }
    it { should_not accept_values_for(:template_id, nil) }
    it { should_not accept_values_for(:field_type, nil, '', '   ', 'foo', 'bar') }
    it { should accept_values_for(:field_type, 'short_text', 'long_text') }

    context "other fields exist" do
      before do
        @field_with_diff_tpl = Factory(:field)
        @field_with_same_tpl = Factory(:field, :template => subject.template)
      end

      it { should accept_values_for(:name, @field_with_diff_tpl.name) }
      it { should_not accept_values_for(:name, @field_with_same_tpl.name) }
    end
  end

end