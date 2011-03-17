require 'spec_helper'

describe Admin::FieldsController, "member actions" do

  before(:all) { @user = Factory(:user) }

  before do
    sign_in :user, @user
    tpl = Factory(:template, :user => @user)
    @field = Factory(:field, :template => tpl)
    @params = HashWithIndifferentAccess.new(:id => @field.id)
  end

  {
    :get => :edit,
    :put => :update,
    :delete => :destroy
  }.each do |http_method, action|
    describe "#{http_method.upcase} #{action}" do
      context "when the id matches a field belonging to the user" do
        before { send(http_method, action, @params) }
        it "assigns the field" do
          assigns(:field).should eq(@field)
        end

        it "assigns the template" do
          assigns(:tpl).should eq(@field.template)
        end
      end

      context "when the id does not match a field belonging to the current user" do
        before do
          @params[:id] = 347890
          send(http_method, action, @params)
        end

        it { response.code.should eq("404") }
        it { response.should render_template("admin/shared/not_found") }
      end
    end
  end

##################################################

  describe "GET edit" do
    context "when the id matches a field belonging to the user" do
      it "renders the edit template" do
        get :edit, @params
        response.should render_template(:edit)
      end
    end
  end

##################################################

  describe "PUT update" do
    context "when the id matches a field belonging to the user" do
      context do
        before { controller.current_user.fields.stub!(:find => @field) }
        after { put :update, @params }

        it "sets the field's attributes from the params" do
          @params[:field] = {:name => 'something'}
          @field.should_receive(:attributes=).with(@params[:field])
        end

        it "updates the field" do
          @field.should_receive(:update)
        end
      end

      context "with invalid params" do
        before do
          @params[:field] = {:name => ''}
          put :update, @params
        end

        it { flash.alert.should eq("Houston, we have some problems.") }
        it { response.should render_template(:edit) }
      end

      context "with valid params" do
        before do
          @params[:field] = {:name => 'something'}
          put :update, @params
        end

        it { flash.notice.should eq("Field was saved.") }
        it { response.should redirect_to(admin_template_fields_url(@field.template)) }
      end
    end
  end

##################################################

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

      it { response.should redirect_to(admin_template_fields_url(@field.template)) }
    end
  end

end