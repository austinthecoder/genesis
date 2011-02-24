require 'spec_helper'

describe Admin::TemplatesController do

  before { sign_in :user, Factory(:user) }

  describe "GET index" do
    it "renders the index template" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "GET new" do
    it "assigns a new template" do
      get :new
      (assigns(:tpl).is_a?(Template) && assigns(:tpl).new_record?).should be_true
    end

    it "renders the new template" do
      get :new
      response.should render_template(:new)
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      before do
        @params = {:template => Factory.attributes_for(:template)}
      end

      it "creates a template for the current user" do
        post :create, @params
        controller.current_user.templates.count.should eq(1)
      end

      it "sets the template's attributes" do
        post :create, @params
        t = Template.last
        @params[:template].each do |k, v|
          t.send(k).should eq(v)
        end
      end

      it "sets a notice" do
        post :create, @params
        flash[:notice].should eq("Wowza weeza! Template was created!")
      end

      it "redirects to the templates" do
        post :create, @params
        response.should redirect_to(admin_templates_url)
      end
    end

    context "with invalid attributes" do
      it "doesn't create a template" do
        post :create
        Template.count.should eq(0)
      end

      it "sets an alert" do
        post :create
        flash[:alert].should eq("Houston, we have some problems.")
      end

      it "renders the 'new' template" do
        post :create
        response.should render_template(:new)
      end
    end
  end

end