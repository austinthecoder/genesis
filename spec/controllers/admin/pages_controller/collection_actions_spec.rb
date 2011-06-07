require 'spec_helper'

describe Admin::PagesController, 'collection actions' do

  before do
    @user = Factory(:user)
    sign_in :user, @user
    @params = HashWithIndifferentAccess.new
  end

  describe "GET index" do
    before do
      2.times { Factory(:page, :user => @user) }
      get :index, @params
    end

    it { response.should render_template(:index) }

    it "assigns the user's pages (arranged)" do
      assigns(:arranged_pages).should eq(@user.pages.arrange)
    end
  end

##################################################

  {
    :get => :new,
    :post => :create
  }.each do |http_method, action|
    describe "#{http_method.upcase} #{action}" do
      it "assigns a template relation for the user" do
        send(http_method, action, @params)
        assigns(:tpls).should eq(@user.templates.order("created_at DESC"))
      end

      context "when a page_id is present" do
        before do
          @page = Factory(:page, :user => @user)
          @params[:page_id] = @page.id
        end

        context "when the page_id belongs to a page for the user" do
          before { send(http_method, action, @params) }

          it "assigns parent_page from the page_id" do
            assigns(:parent_page).should eq(@page)
          end

          it "assigns a new page under that page" do
            assigns(:page).attributes.should eq(@page.children.new.attributes.merge(
              "user_id" => @user.id
            ))
          end
        end

        context "when the page_id does not belong to a page for the user" do
          before do
            @params[:page_id] = 4523709
            send(http_method, action, @params)
          end

          it { response.code.should eq("404") }
          it { response.should render_template("admin/shared/not_found") }
        end
      end

      context "when a page_id is not present" do
        before { send(http_method, action, @params) }

        it "assigns a new page for the current user" do
          assigns(:page).attributes.should eq(controller.current_user.pages.new.attributes)
        end
      end
    end
  end

##################################################

  describe "GET new" do
    before { get :new, @params }

    it { response.should render_template(:new) }
  end

##################################################

  describe "POST create" do
    context "with no page_id present" do
      context "with valid page params" do
        before do
          @nbr_pages = controller.current_user.pages.size
          @params[:page] = {:title => "My Page"}
          post :create, @params
          @user.reload
          @newest_page = @user.pages.order('id ASC').first
        end

        it "creates a page for the user from the params" do
          @user.pages.size.should eq(@nbr_pages + 1)
          @newest_page.title.should eq("My Page")
        end

        it { flash.notice.should eq("Page was saved.") }
        it { response.should redirect_to(edit_admin_page_url(@newest_page)) }
      end

      context "with invalid page params" do
        before do
          @page_count = Page.count
          @params[:page] = {}
          post :create, @params
        end

        it "does not create a page" do
          Page.count.should eq(@page_count)
        end

        it { flash.alert.should eq("Houston, we have some problems.") }
        it { response.should render_template(:new) }
      end
    end

    context "with a page_id present" do
      before do
        @page = Factory(:page, :user => @user)
        @params[:page_id] = @page.id
      end

      context "when the page_id belongs to a page for the user" do
        context "with valid page params" do
          before do
            @nbr_pages = @page.children.size
            @params[:page] = {:title => "My Subpage", :slug => 'myslug'}
            post :create, @params
            @page.reload
            @newest_child = @page.children.order('id ASC').first
          end

          it "creates a subpage under that page from the params" do
            @page.children.size.should eq(@nbr_pages + 1)
            @newest_child.title.should eq("My Subpage")
            @newest_child.slug.should eq("myslug")
            @newest_child.user_id.should eq(@user.id)
          end

          it { response.should redirect_to(edit_admin_page_url(@newest_child)) }
        end

        context "with invalid page params" do
          before do
            @page_count = Page.count
            @params[:page] = {}
            post :create, @params
          end

          it "does not create a page" do
            Page.count.should eq(@page_count)
          end

          it { response.should render_template(:new) }
        end
      end
    end
  end

end