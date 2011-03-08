require 'spec_helper'

describe Admin::PagesController do

  before(:all) do
    @user = Factory(:user)
  end

  before do
    sign_in :user, @user
    @params = HashWithIndifferentAccess.new
  end

  describe "GET index" do
    it "renders the index template" do
      get :index, @params
      response.should render_template('index')
    end

    it "assigns the user's pages (arranged)" do
      2.times { Factory(:page) }
      pages = [2, 1, 3].map do |i|
        p = Factory(:page, :user => @user, :created_at => i.minutes.ago)
        [2, 1, 3].map do |j|
          Factory(:page,
            :user => @user,
            :created_at => j.minutes.ago,
            :parent => p,
            :slug => 'myslug'
          )
        end
      end
      get :index, @params
      assigns(:arranged_pages).should eq(@user.pages.arrange)
    end
  end

  describe "GET new" do
    context "with no page_id present" do
      before { get :new, @params }

      it { response.should render_template(:new) }

      it "assigns a new page for the current user" do
        assigns(:page).attributes.should eq(controller.current_user.pages.new.attributes)
      end
    end

    context "with a page_id present" do
      before do
        @page = Factory(:page, :user => @user)
        @params[:page_id] = @page.id
      end

      context "when the page_id belongs to a page for the user" do
        before { get :new, @params }

        it "assigns the parent page" do
          assigns(:parent_page).should eq(@page)
        end

        it "assigns a new page under that page" do
          assigns(:page).attributes.should eq(@page.children.new.attributes.merge("user_id" => @user.id))
        end

        it { response.should render_template(:new) }
      end

      context "when the page_id does not belong to a page for the user"
    end
  end

  describe "POST create" do
    context "with no page_id present" do
      context "with valid page params" do
        before do
          @params[:page] = {:title => "My Page"}
          post :create, @params
        end

        it "creates a page for the user from the params" do
          controller.current_user.pages.size.should eq(1)
          controller.current_user.pages.first.title.should eq("My Page")
        end

        it { flash[:notice].should eq("Page was added.") }
        it { response.should redirect_to(admin_pages_url) }
      end

      context "with invalid page params"
    end

    context "with a page_id present" do
      before do
        @page = Factory(:page, :user => @user)
        @params[:page_id] = @page.id
      end

      context "when the page_id belongs to a page for the user" do
        context "with valid page params" do
          before do
            @params[:page] = {:title => "My Subpage", :slug => 'myslug'}
            post :create, @params
          end

          it "assigns the parent page" do
            assigns(:parent_page).should eq(@page)
          end

          it "creates a subpage under that page from the params" do
            @page.reload
            @page.children.size.should eq(1)
            @page.children.first.tap do |p|
              p.title.should eq("My Subpage")
              p.slug.should eq("myslug")
              p.user_id.should eq(@user.id)
            end
          end

          it { response.should redirect_to(admin_pages_url) }
        end

        context "with invalid page params" do
          before do
            @page_count = Page.count
            @params[:page] = {}
            post :create, @params
          end

          it "assigns the parent page" do
            assigns(:parent_page).should eq(@page)
          end

          it "does not create a page" do
            Page.count.should eq(@page_count)
          end

          it { response.should render_template(:new) }
        end
      end

      context "when the page_id does not belong to a page for the user"
    end
  end

  describe "member actions" do
    before do
      @page = Factory(:page, :user => @user)
      @params[:id] = @page.id
    end

    describe "GET edit" do
      before { get :edit, @params }

      it { response.should render_template(:edit) }

      it "assigns the page" do
        assigns(:page).should eq(@page)
      end
    end
  end

end