require 'spec_helper'

describe Admin::PagesController, "member actions" do

  before(:all) { @user = Factory(:user) }

  before do
    sign_in :user, @user
    @page = Factory(:page, :user => @user)
    @params = HashWithIndifferentAccess.new(:id => @page.id)
  end

  {
    :get => :edit,
    :put => :update,
    :get => :edit_template,
    :delete => :destroy
  }.each do |http_method, action|
    describe "#{http_method.upcase} #{action}" do
      context "when the id matches a page belonging to the user" do
        before { send(http_method, action, @params) }

        it "assigns the page" do
          assigns(:page).should eq(@page)
        end

        it "assigns a template relation for the user" do
          assigns(:tpls).should eq(@user.templates.order("created_at DESC"))
        end
      end

      context "when the id doesn't match a page belonging to the user" do
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
    context "when the id matches a page belonging to the user" do
      before { get :edit, @params }

      it { response.should render_template(:edit) }
    end
  end

##################################################

  describe "PUT update" do
    context "when the id matches a page belonging to the user" do
      context "with valid page params" do
        before { @params[:page] = {:title => 'My Page'} }

        it "updates the page from the params" do
          page = mock_model(Page)
          controller.current_user.pages.stub!(:find => page)
          page.should_receive(:update_attributes!).with(@params[:page])
          put :update, @params
        end

        it "sets a flash notice" do
          put :update, @params
          flash.notice.should eq("Page was saved.")
        end

        it "redirects to the edit page" do
          put :update, @params
          response.should redirect_to(edit_admin_page_url(@page))
        end
      end

      context "with invalid page params" do
        before do
          @params[:page] = {:title => ''}
          put :update, @params
        end

        it { flash.alert.should eq("Houston, we have some problems.") }

        it { response.should render_template(:edit) }
      end
    end
  end

##################################################

  describe "GET edit_template" do
    context "when the id matches a page belonging to the user" do
      before { get :edit_template, @params }

      it { response.should render_template(:edit_template) }
    end
  end

##################################################

  describe "DELETE destroy" do
    context "when the id matches a page belonging to the user" do
      before { delete :destroy, @params }

      it { lambda { @page.reload }.should raise_error(ActiveRecord::RecordNotFound) }

      it "sets a notice with an undo link" do
        path = revert_admin_version_path(@page.versions.scoped.last)
        undo_button = controller.view_context.button_to("Undo", path)
        flash.notice.should eq("Page was removed. #{undo_button}")
      end

      it { response.should redirect_to(admin_pages_url) }
    end
  end

end