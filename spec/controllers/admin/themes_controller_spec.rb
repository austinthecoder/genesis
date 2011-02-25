require 'spec_helper'

describe Admin::ThemesController do

  before { sign_in :user, Factory(:user) }

  describe "GET show" do
    it "assigns the templates for the current user" do
      2.times { Factory(:template) }
      @tpls = (1..3).map { |i| Factory(:template, :user => controller.current_user) }
      get :show
      assigns(:tpls).should eq(@tpls)
    end

    it "renders the show template" do
      get :show
      response.should render_template(:show)
    end
  end

end