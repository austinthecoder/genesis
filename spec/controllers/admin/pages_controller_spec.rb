require 'spec_helper'

describe Admin::PagesController do

  before { sign_in :user, Factory(:user) }

  describe "GET dashboard" do
    it "renders the dashboard template" do
      get :dashboard
      response.should render_template('dashboard')
    end
  end

end