require 'spec_helper'

describe Admin::Users::SessionsController do

  describe "#after_sign_in_path_for" do
    context "with a user" do
      it { controller.after_sign_in_path_for(User.new).should eq(admin_root_url) }
    end
  end

end