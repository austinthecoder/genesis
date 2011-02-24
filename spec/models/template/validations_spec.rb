require 'spec_helper'

describe Template, 'validations' do

  context "a new template with valid attributes" do
    subject { Factory.build(:template) }

    it { should be_valid }

    it { should_not accept_values_for(:name, nil, '', ' ') }

    it { should_not accept_values_for(:user_id, nil) }

    context "when template exists for the same user with the name 'Home'" do
      before { Factory(:template, :user => subject.user, :name => 'Home') }

      it { should_not accept_values_for(:name, 'Home') }
    end
  end

end