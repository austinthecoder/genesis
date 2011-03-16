require 'spec_helper'

describe User, 'class methods' do

  describe ".find_for_authentication" do
    before { @conditions = {:site_id => 2134, :email => 'a@b.com'} }

    context "when a site exists for the site_id" do
      before { @site = Factory(:site, :id => 2134) }

      context "when a user exists for that site" do
        before { @user = Factory(:user, :email => 'a@b.com', :site => @site) }

        it "returns that user" do
          User.find_for_authentication(@conditions).should eq(@user)
        end

        it "returned user is not readonly" do
          User.find_for_authentication(@conditions).should_not be_readonly
        end
      end

      context "when a user does not exist for that site" do
        before { Factory(:user, :email => 'a@b.com') }

        it "returns nil" do
          User.find_for_authentication(@conditions).should be_nil
        end
      end
    end

    context "when a site doesn't exist for the site_id" do
      it "returns nil" do
        User.find_for_authentication(@conditions).should be_nil
      end
    end
  end

end