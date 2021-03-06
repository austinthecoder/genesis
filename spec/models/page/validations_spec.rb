require 'spec_helper'

describe Page, 'validations' do

  context "for a new user with valid attributes" do
    before { @bad_slugs = %w(a/b a#b a$b a@b a!b a%b a^b a&b a*b a(b a)b a[b a]b a{b a}b a+b a=b) }

    subject { Factory.build(:page) }

    it { should be_valid }

    it { should_not accept_values_for(:user_id, nil) }

    %w(title template_id).each do |attr|
      it { should_not accept_values_for(attr, '', '  ', nil) }
    end

    context "when it is a root page" do
      it { should_not accept_values_for(:slug, *@bad_slugs) }
      it { should_not accept_values_for(:slug, 'myslug') }
      it { should accept_values_for(:slug, '', '  ', nil) }
    end

    context "when it is a sub-page" do
      before { subject.parent = Factory(:page) }

      it { should_not accept_values_for(:slug, '', '  ', nil) }
      it { should_not accept_values_for(:slug, *@bad_slugs) }
      it { should accept_values_for(:slug, 'myslug') }

      it "slug must be unique among siblings" do
        Factory(:sub_page, :parent => subject.parent, :slug => 'a')
        should_not accept_values_for(:slug, 'a')
      end
    end

    # user_id must match parent on update
  end

end