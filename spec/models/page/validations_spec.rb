require 'spec_helper'

describe Page, 'validations' do

  context "for a new user with valid attributes" do
    subject { Factory.build(:page) }

    it { should be_valid }

    it { should_not accept_values_for(:user_id, nil) }
    it { should_not accept_values_for(:title, '', '  ', nil) }

    context "when it is a root page" do
      it { should_not accept_values_for(:slug, "myslug") }
      it { should accept_values_for(:slug, '', '  ', nil) }
    end

    context "when it is a sub-page" do
      before { subject.parent = Factory(:page) }

      it { should_not accept_values_for(:slug, '', '  ', nil) }
      it { should accept_values_for(:slug, "myslug") }
    end

    # user_id must match parent on update
  end

end