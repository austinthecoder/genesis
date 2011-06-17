require 'spec_helper'

describe Admin::TemplatesController, "member actions" do

  before do
    @user = Factory(:user)
    sign_in :user, @user
    @tpl = Factory(:template, :user => @user, :updated_at => 10.minutes.ago)
    @params = HashWithIndifferentAccess.new(:id => @tpl.id)
  end

  {
    :get => :edit,
    :put => :update,
    :delete => :destroy
  }.each do |http_method, action|
    describe "#{http_method.upcase} #{action}" do
      context "when the id matches a template belonging to the user" do
        before { send(http_method, action, @params) }

        it "assigns a template relation for the user" do
          assigns(:tpls).should eq(@user.templates.order("created_at DESC"))
        end

        it "assigns the template" do
          assigns(:tpl).should eq(@tpl)
        end
      end

      context "when the id doesn't match a template belonging to the user" do
        before do
          @params[:id] = 5479032
          send(http_method, action, @params)
        end

        it { response.code.should eq("404") }
        it { response.should render_template("admin/shared/not_found") }
      end
    end
  end

##################################################

  describe "GET edit" do
    context "when the id matches a template belonging to the user" do
      before { get :edit, @params }

      it { response.should render_template(:edit) }
    end
  end

##################################################

  describe "PUT update" do
    context "when the id matches a template belonging to the user" do
      context "with valid params" do
        before do
          @params[:template] = {:name => 'foosbars', :content => 'skeeza mcgeeza'}
          put :update, @params
        end
        
        it { response.should redirect_to(edit_admin_template_url(@tpl)) }

        it "updates the template from the params" do
          t = Template.find(@tpl.id)
          t.name.should eq('foosbars')
          t.content.should eq('skeeza mcgeeza')
        end
      end

      context "with invalid params" do
        before do
          @updated_at = @tpl.updated_at
          @params[:template] = {:name => ''}
          put :update, @params
        end
        
        it { response.should render_template(:edit) }

        it "does not update the template" do
          Template.find(@tpl.id).updated_at.to_i.should eq(@updated_at.to_i)
        end
      end
    end
  end

##################################################

  describe "DELETE destroy" do
    context "when the id matches a template belonging to the user" do
      before { delete :destroy, @params }

      it "destroys the template" do
        lambda { @tpl.reload }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "sets a notice with an undo link" do
        path = revert_admin_version_path(@tpl.versions.scoped.last)
        undo_button = controller.view_context.button_to("Undo", path)
        flash.notice.should eq("Template was removed. #{undo_button}")
      end

      it { response.should redirect_to(admin_theme_url) }
    end
  end

end