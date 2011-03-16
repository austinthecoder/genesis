require 'spec_helper'

describe Admin::Users::SessionsController do

  # before(:all) { @user = Factory(:user) }

  before do
    @domain = "example.com"
    request.host = @domain
    request.env["devise.mapping"] = Devise.mappings[:user]
    # sign_in :user, @user
    @params = HashWithIndifferentAccess.new
  end

  describe "POST create" do
    before do
      @site = Factory(:site, :domain => @domain)

    end

    # context "when the params contains a user hash" do
    #   before { @params[:user] = {} }
    #
    #   it "adds the site_id to that hash" do
    #     post :create, @params
    #     controller.params[:user][:site_id].should eq(@site.id)
    #   end
    # end
    #
    # context "when the params does not contain a user hash" do
    #   it "doesn't add a site_id to the hash" do
    #     @params_before_request = @params.dup
    #     post :create, @params
    #     controller.params.should eq(@params_before_request)
    #   end
    # end
  end

##################################################

  describe "#after_sign_in_path_for" do
    it { controller.after_sign_in_path_for(User.new).should eq(admin_root_url) }

    it { controller.after_sign_out_path_for(:user).should eq(new_user_session_url) }
  end

end