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
    :get => :edit_template
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

end