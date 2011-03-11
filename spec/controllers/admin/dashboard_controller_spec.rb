require 'spec_helper'

describe Admin::DashboardController do

  before { sign_in :user, Factory(:user) }

  describe "GET index" do
    it "renders the index template" do
      get :index
      response.should render_template(:index)
    end
  end

end