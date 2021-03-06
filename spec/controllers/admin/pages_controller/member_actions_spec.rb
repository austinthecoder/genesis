require 'spec_helper'

describe Admin::PagesController, "member actions" do

  before do
    @user = Factory(:user)
    sign_in :user, @user
    @page = Factory(:page, :user => @user, :updated_at => 10.minutes.ago)
    @params = HashWithIndifferentAccess.new(:id => @page.id)
  end

  [
    [:get, :edit],
    [:put, :update],
    [:get, :edit_template],
    [:delete, :destroy]
  ].each do |http_method, action|
    describe "#{http_method.upcase} #{action}" do
      context "when the id matches a page belonging to the user" do
        before { send(http_method, action, @params) }

        it "assigns the page" do
          assigns(:page).should eq(@page)
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

  [
    [:get, :edit],
    [:put, :update]
  ].each do |http_method, action|
    describe "#{http_method.upcase} #{action}" do
      context "when the id matches a page belonging to the user" do
        before { send(http_method, action, @params) }
        it "assigns a template relation for the user" do
          assigns(:tpls).should eq(@user.templates.order("created_at DESC"))
        end
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
        before { @params[:page] = {:title => 'New title'} }

        it "updates the page" do
          updated_at = @page.updated_at
          put :update, @params
          @page.reload.updated_at.to_s.should_not == updated_at.to_s
        end

        describe "updated page" do
          subject { @page.reload }
          before { put :update, @params }
          its(:title) { should == 'New title' }
        end

        context "after requesting" do
          before { put :update, @params }
          it { response.should redirect_to(edit_admin_page_url(@page)) }
        end
      end

      context "with invalid page params" do
        before do
          @params[:page] = {:title => ''}
          put :update, @params
        end
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