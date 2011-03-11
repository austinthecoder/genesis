require 'spec_helper'

describe Admin::ThemesController do

  before(:all) { @user = Factory(:user) }

  before { sign_in :user, @user }

  describe "GET show" do
    before { get :show }

    it "assigns an ordered template relation for the user" do
      assigns(:tpls).should eq(@user.templates.order("created_at DESC"))
    end

    it { response.should render_template(:show) }
  end

end