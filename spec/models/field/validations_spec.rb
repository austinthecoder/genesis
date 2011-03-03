require 'spec_helper'

describe Field, 'validations' do

  context "a new field with valid attributes" do
    subject { Factory.build(:field) }

    it { should be_valid }
    it { should_not accept_values_for(:name, nil, '', ' ') }
  end

end