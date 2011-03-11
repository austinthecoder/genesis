require 'spec_helper'

describe Admin::FieldsController, "collection actions" do

  before(:all) { @user = Factory(:user) }

  before do
    sign_in :user, @user
    @tpl = Factory(:template, :user => @user)
    @params = HashWithIndifferentAccess.new(:template_id => @tpl.id)
  end

  {
    :get => :index,
    :post => :create
  }.each do |http_method, action|
    describe "#{http_method.upcase} #{action}" do
      context "when the template_id matches a template belonging to the current user" do
        before { send(http_method, action, @params) }

        it "assigns the template" do
          assigns(:tpl).should eq(@tpl)
        end

        it "assigns a new field belonging to the template" do
          assigns(:field).attributes.should eq(@tpl.fields.new.attributes)
        end

        it "assigns an ordered field relation for the template" do
          assigns(:fields).should eq(@tpl.fields.order('created_at ASC'))
        end
      end

      context "when the template_id does not match a template belonging to the current user" do
        before do
          @params[:template_id] = 347890
          send(http_method, action, @params)
        end

        it { response.code.should eq("404") }
        it { response.should render_template("admin/shared/not_found") }
      end
    end
  end

##################################################

  describe "GET index" do
    context "when the template_id matches a template belonging to the current user" do
      before { get :index, @params }

      it { response.should render_template(:index) }
    end
  end

##################################################

  describe "POST create" do
    context "when the template_id matches a template belonging to the current user" do
      context "with valid field params" do
        before do
          @params.merge!(:field => {:name => 'foo', :field_type => 'short_text'})
          post :create, @params
        end

        it "creates a field for the template with attributes from the params" do
          assigns(:tpl).reload
          assigns(:tpl).fields.size.should eq(1)
          @params[:field].each { |k, v| assigns(:tpl).fields[0].send(k).should eq(v) }
        end

        it { flash.notice.should eq("Kablam! Added!") }
        it { response.should redirect_to(admin_template_fields_url(assigns(:tpl))) }
      end

      context "with invalid field params" do
        before { post :create, @params }

        it { Field.count.should eq(0) }
        it { flash.alert.should eq("Dag nabbit. There were some problems.") }
        it { response.should render_template(:index) }
      end
    end
  end

end