require 'spec_helper'

describe Admin::FieldsController, "collection actions" do

  before do
    @user = Factory(:user)
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
        field_attrs = {:name => 'foo', :field_type => 'short_text'}
        before { @params.merge!(:field => field_attrs) }

        it "creates a field" do
          lambda { post :create, @params }.should change { @tpl.fields.count }.by(1)
        end

        describe "the created field" do
          subject { @tpl.fields.last }
          before { post :create, @params }

          field_attrs.each do |name, value|
            its(name) { should eq(value) }
          end
        end

        context "after request" do
          before { post :create, @params }
          it { response.should redirect_to(admin_template_fields_url(assigns(:tpl))) }
        end
      end

      context "with invalid field params" do
        it "doesn't create a field" do
          lambda { post :create, @params }.should_not change { Field.count }
        end

        context "after request" do
          before { post :create, @params }
          it { response.should render_template(:index) }
        end
      end
    end
  end

end