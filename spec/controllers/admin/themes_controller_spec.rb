require 'spec_helper'

describe Admin::ThemesController do

  before(:all) do
    @user = Factory(:user)
    2.times { Factory(:template) }
    @users_tpls = (1..3).map { |i| Factory(:template, :user => @user) }
  end

  before { sign_in :user, @user }

  describe "GET show" do
    before { get :show }

    it "assigns the templates for the current user" do
      assigns(:tpls).sort_by { |t| t.id }.should eq(@users_tpls.sort_by { |t| t.id })
    end

    it { response.should render_template(:show) }
  end

end