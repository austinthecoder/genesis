require 'spec_helper'

describe Admin::FieldsController do

  before(:all) {
    @user = Factory(:user)
    @tpl = Factory(:template, :user => @user)
  }

  before do
    sign_in :user, @user
    @params = HashWithIndifferentAccess.new(:template_id => @tpl.id)
  end

  {
    :get => :index,
    :post => :create
  }.each do |http_method, action|
    describe "#{http_method.upcase} #{action}" do
      context "when the template_id matches a template belonging to the current user" do
        it "assigns the template" do
          send(http_method, action, @params)
          assigns(:tpl).should eq(@tpl)
        end

        it "assigns the fields for the template (oldest first)" do
          2.times { Factory(:field) }
          tpl_fields = [2, 3, 1].map do |i|
            Factory(:field, :template => @tpl, :created_at => i.minutes.ago)
          end
          send(http_method, action, @params)
          assigns(:fields).should eq([tpl_fields[1], tpl_fields[0], tpl_fields[2]])
        end
      end

      context "when the template_id does not match a template belonging to the current user" do
        before do
          @params.merge!(:template_id => Factory(:template).id)
          send(http_method, action, @params)
        end

        it { response.code.should eq("404") }
        it { response.should render_template("admin/shared/not_found") }
      end
    end
  end

  describe "GET index" do
    before { get :index, @params }

    it { response.should render_template(:index) }

    it "assigns a new field belonging to the template" do
      assigns(:field).should be_a_new(Field)
      assigns(:field).template.should eq(assigns(:tpl))
    end
  end

  describe "POST create" do
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

  describe "member actions" do
    before do
      @field = Factory(:field, :template => @tpl)
      @params[:id] = @field.id
    end

    describe "DELETE destroy" do
      context "when the id matches a field belonging to the user" do
        before { delete :destroy, @params }

        it "destroys the field" do
          lambda do
            @field.reload
          end.should raise_error(ActiveRecord::RecordNotFound, "Couldn't find Field with ID=#{@field.id}")
        end

        it "sets a notice with an undo link" do
          path = revert_admin_version_path(@field.versions.scoped.last)
          undo_button = controller.view_context.button_to("Undo", path)
          flash.notice.should eq("Field was removed. #{undo_button}")
        end

        it { response.should redirect_to(admin_template_fields_url(@tpl)) }
      end

      context "when the id matches a field not belonging to the user" do
        before do
          @other_field = Factory(:field)
          @params[:id] = @other_field.id
          delete :destroy, @params
        end

        it { response.code.should eq("404") }
        it { response.should render_template("admin/shared/not_found") }

        it "does not destroy the field" do
          lambda { @other_field.reload }.should_not raise_error
        end
      end

      context "when the id does not match a field for any user" do
        before do
          @params[:id] = 9874651
          delete :destroy, @params
        end

        it { response.code.should eq("404") }
        it { response.should render_template("admin/shared/not_found") }
      end
    end
  end

end