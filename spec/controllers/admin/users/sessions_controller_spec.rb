require 'spec_helper'

describe Admin::Users::SessionsController do

  describe "#after_sign_in_path_for" do
    it { controller.after_sign_in_path_for(User.new).should eq(admin_root_url) }

    it { controller.after_sign_out_path_for(:user).should eq(new_user_session_url) }
  end

end