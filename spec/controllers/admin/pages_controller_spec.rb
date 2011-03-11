require 'spec_helper'

describe Admin::PagesController do

  before(:all) do
    @user = Factory(:user)
  end

  before do
    sign_in :user, @user
    @params = HashWithIndifferentAccess.new
  end

##################################################

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

##################################################

  {
    :get => :new,
    :post => :create
  }.each do |http_method, action|
    describe "#{http_method.upcase} #{action}" do
      it "assigns the templates for the current user (newest first)" do
        2.times { Factory(:template) }
        @user_tpls = [2, 3, 1].map do |i|
          Factory(:template, :user => @user, :created_at => i.minutes.ago)
        end
        send(http_method, action, @params)
        assigns(:tpls).should eq([@user_tpls[2], @user_tpls[0], @user_tpls[1]])
      end

      context "with a page_id present" do
        before do
          @page = Factory(:page, :user => @user)
          @params[:page_id] = @page.id
        end

        context "when the page_id belongs to a page for the user" do
          it "assigns parent_page from the page_id" do
            send(http_method, action, @params)
            assigns(:parent_page).should eq(@page)
          end
        end
      end
    end
  end

##################################################

  describe "GET new" do
    context "with no page_id present" do
      before { get :new, @params }

      it "assigns a new page for the current user" do
        assigns(:page).attributes.should eq(controller.current_user.pages.new.attributes)
      end

      it { response.should render_template(:new) }
    end

    context "with a page_id present" do
      before do
        @page = Factory(:page, :user => @user)
        @params[:page_id] = @page.id
      end

      context "when the page_id belongs to a page for the user" do
        before { get :new, @params }

        it "assigns a new page under that page" do
          assigns(:page).attributes.should eq(@page.children.new.attributes.merge("user_id" => @user.id))
        end

        it { response.should render_template(:new) }
      end

      context "when the page_id does not belong to a page for the user" do
        before do
          @params[:page_id] = 4523709
          get :new, @params
        end

        it { response.code.should eq("404") }
        it { response.should render_template("admin/shared/not_found") }
      end
    end
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

      context "when the page_id does not belong to a page for the user" do
        before do
          @page = Factory(:page, :user => @user)
          @params[:page_id] = 5479032
          post :create, @params
        end

        it { response.code.should eq("404") }
        it { response.should render_template("admin/shared/not_found") }
      end
    end
  end

##################################################

  describe "member actions" do
    before do
      @page = Factory(:page, :user => @user)
      @params[:id] = @page.id
    end

    {
      :get => :edit,
      :put => :update,
      :get => :edit_template
    }.each do |http_method, action|
      describe "#{http_method.upcase} #{action}" do
        it "assigns the templates for the current user (newest first)" do
          2.times { Factory(:template) }
          @user_tpls = [2, 3, 1].map do |i|
            Factory(:template, :user => @user, :created_at => i.minutes.ago)
          end
          send(http_method, action, @params)
          assigns(:tpls).should eq([@user_tpls[2], @user_tpls[0], @user_tpls[1]])
        end

        it "assigns the page" do
          send(http_method, action, @params)
          assigns(:page).should eq(@page)
        end
      end
    end

    describe "GET edit" do
      before { get :edit, @params }

      it { response.should render_template(:edit) }
    end

    describe "PUT update" do
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

        it { response.should render_template(:edit) }
      end
    end

    # describe "GET edit_template" do
    #   before { get :edit_template, @params }
    #
    #   it { response.should render_template(:edit) }
    # end
  end

end