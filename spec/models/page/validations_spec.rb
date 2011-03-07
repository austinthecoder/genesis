require 'spec_helper'

describe Page, 'validations' do

  context "for a new user with valid attributes" do
    subject { Factory.build(:page) }

    it { should be_valid }

    it { should_not accept_values_for(:user_id, nil) }

    it "slug must be blank for root page" do
      should_not accept_values_for(:slug, "myslug")
      should accept_values_for(:slug, '', '  ', nil)
    end

    # user_id must match parent on update
  end

end