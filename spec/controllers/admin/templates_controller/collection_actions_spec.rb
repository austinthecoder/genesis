require 'spec_helper'

describe Admin::TemplatesController, "collection actions" do

  before do
    @user = Factory(:user)
    sign_in :user, @user
    @params = HashWithIndifferentAccess.new
  end

  {
    :get => :new,
    :post => :create
  }.each do |http_method, action|
    describe "#{http_method.upcase} #{action}" do
      before { send(http_method, action, @params) }

      it "assigns a template relation for the user" do
        assigns(:tpls).should eq(@user.templates.order("created_at DESC"))
      end
    end
  end

##################################################

  describe "GET new" do
    before { get :new }

    it { response.should render_template(:new) }

    it "assigns a new template for the user" do
      assigns(:tpl).attributes.should eq(@user.templates.new.attributes)
    end
  end

##################################################

  describe "POST create" do
    context "with valid attributes" do
      before do
        @params[:template] = {:name => 'n', :content => 'c'}
        post :create, @params
      end

      it "creates a template for the current user" do
        @user.templates.count.should eq(1)
      end

      it "sets the template's attributes" do
        t = controller.current_user.templates.order("created_at DESC").first
        t.name.should eq('n')
        t.content.should eq('c')
      end

      it "redirects to the edit template url" do
        response.should redirect_to(edit_admin_template_url(Template.last))
      end
    end

    context "with invalid attributes" do
      before do
        @nbr_tpls = Template.count
        post :create
      end

      it { response.should render_template(:new) }

      it "doesn't create a template" do
        Template.count.should eq(@nbr_tpls)
      end
    end
  end

end