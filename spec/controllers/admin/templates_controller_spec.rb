require 'spec_helper'

describe Admin::TemplatesController do

  before(:all) do
    @user = Factory(:user)
    2.times { Factory(:template) }
    @user_tpls = [2, 3, 1].map do |i|
      Factory(:template, :user => @user, :created_at => i.minutes.ago)
    end
  end

  before do
    sign_in :user, @user
    @params = HashWithIndifferentAccess.new
  end

  ##################################################

  describe "GET new" do
    before { get :new }

    it "assigns a new template" do
      (assigns(:tpl).is_a?(Template) && assigns(:tpl).new_record?).should be_true
    end

    it "assigns the templates for the current user (newest first)" do
      assigns(:tpls).should eq([@user_tpls[2], @user_tpls[0], @user_tpls[1]])
    end

    it { response.should render_template(:new) }
  end

  ##################################################

  describe "POST create" do
    context "with valid attributes" do
      before do
        @params[:template] = {:name => 'n', :content => 'c'}
        post :create, @params
      end

      it "creates a template for the current user" do
        controller.current_user.templates.count.should eq(@user_tpls.size + 1)
      end

      it "sets the template's attributes" do
        t = controller.current_user.templates.order("created_at DESC").first
        t.name.should eq('n')
        t.content.should eq('c')
      end

      it { flash[:notice].should eq("Wowza weeza! Template was created!") }

      it "redirects to the edit template url" do
        response.should redirect_to(edit_admin_template_url(Template.last))
      end
    end

    context "with invalid attributes" do
      before do
        @nbr_tpls = Template.count
        post :create
      end

      it "doesn't create a template" do
        Template.count.should eq(@nbr_tpls)
      end

      it "assigns the templates for the current user (newest first)" do
        assigns(:tpls).should eq([@user_tpls[2], @user_tpls[0], @user_tpls[1]])
      end

      it { flash[:alert].should eq("Houston, we have some problems.") }
      it { response.should render_template(:new) }
    end
  end

  ##################################################

  describe "member actions" do
    before do
      @tpl = Factory(:template, :user => @user)
      @params[:id] = @tpl.id
    end

    describe "GET edit" do
      context "when the id matches a template belonging to the user" do
        before { get :edit, @params }

        it "assigns the templates for the current user (newest first)" do
          assigns(:tpls).should eq([@tpl, @user_tpls[2], @user_tpls[0], @user_tpls[1]])
        end

        it "assigns the template" do
          assigns(:tpl).should eq(@tpl)
        end

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

          it "assigns the template" do
            assigns(:tpl).should eq(@tpl)
          end

          it "updates the template from the params" do
            t = Template.find(@tpl.id)
            t.name.should eq('foosbars')
            t.content.should eq('skeeza mcgeeza')
          end

          it { response.should redirect_to(edit_admin_template_url(@tpl)) }
        end

        context "with invalid params" do
          before do
            @updated_at = @tpl.updated_at
            @params[:template] = {:name => ''}
            put :update, @params
          end

          it "assigns the templates for the current user (newest first)" do
            assigns(:tpls).should eq([@tpl, @user_tpls[2], @user_tpls[0], @user_tpls[1]])
          end

          it { flash[:alert].should eq("Houston, we have some problems.") }

          it "assigns the template" do
            assigns(:tpl).should eq(@tpl)
          end

          it "does not update the template" do
            Template.find(@tpl.id).updated_at.should eq(@updated_at)
          end

          it { response.should render_template(:edit) }
        end
      end
    end
  end

end