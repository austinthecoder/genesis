require 'spec_helper'

describe Admin::TemplatesController do

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
    it "creates a template" do
      post :create
      Template.count.should eq(1)
    end

    it "the created template's attributes are set from the params" do
      post :create, :template => {:content => "frogs like candy"}
      Template.last.content.should eq("frogs like candy")
    end

    it "sets a notice" do
      post :create
      flash[:notice].should eq("Wowza weeza! Template was created!")
    end

    it "redirects to the templates" do
      post :create
      response.should redirect_to(admin_templates_url)
    end
  end

end