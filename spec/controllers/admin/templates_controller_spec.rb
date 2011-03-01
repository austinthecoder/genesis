require 'spec_helper'

describe Admin::TemplatesController do

  before do
    sign_in :user, Factory(:user)
    2.times { Factory(:template) }
    @user_tpls = (1..3).map { |i| Factory(:template, :user => controller.current_user) }
    @params = HashWithIndifferentAccess.new
  end

  ##################################################

  describe "GET new" do
    before { get :new }

    it "assigns a new template" do
      (assigns(:tpl).is_a?(Template) && assigns(:tpl).new_record?).should be_true
    end

    it "assigns the templates for the current user" do
      assigns(:tpls).sort_by(&:id).should eq(@user_tpls.sort_by(&:id))
    end

    it { response.should render_template(:new) }
  end

  ##################################################

  describe "POST create" do
    context "with valid attributes" do
      before { post :create, :template => {:name => 'n', :content => 'c'} }

      it "creates a template for the current user" do
        controller.current_user.templates.count.should eq(4)
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
      before { post :create }

      it "doesn't create a template" do
        Template.count.should eq(5)
      end

      it "assigns the templates for the current user" do
        assigns(:tpls).should eq(@user_tpls)
      end

      it { flash[:alert].should eq("Houston, we have some problems.") }

      it { response.should render_template(:new) }
    end
  end

  ##################################################

  describe "member actions" do
    describe "GET edit" do
      context "when the id matches a template belonging to the user" do
        before { get :edit, :id => @user_tpls[1].id }

        it "assigns the templates for the current user" do
          assigns(:tpls).should eq(@user_tpls)
        end

        it "assigns the template" do
          assigns(:tpl).should eq(@user_tpls[1])
        end

        it { response.should render_template(:edit) }
      end
    end

    ##################################################

    describe "PUT update" do
      context "when the id matches a template belonging to the user" do
        before { @params[:id] = @user_tpls[1].id }

        context "with valid params" do
          before do
            put :update, @params.merge(:template => {
              :name => 'foosbars',
              :content => 'skeeza mcgeeza'
            })
          end

          it "assigns the template" do
            assigns(:tpl).should eq(@user_tpls[1])
          end

          it "updates the template from the params" do
            t = Template.find(@user_tpls[1].id)
            t.name.should eq('foosbars')
            t.content.should eq('skeeza mcgeeza')
          end

          it { response.should redirect_to(edit_admin_template_url(@user_tpls[1])) }
        end

        context "with invalid params" do
          before do
            @updated_at = @user_tpls[1].updated_at
            put :update, @params.merge(:template => {:name => ''})
          end

          it "assigns the templates for the current user" do
            assigns(:tpls).should eq(@user_tpls)
          end

          it { flash[:alert].should eq("Houston, we have some problems.") }

          it "assigns the template" do
            assigns(:tpl).should eq(@user_tpls[1])
          end

          it "does not update the template" do
            Template.find(@user_tpls[1].id).updated_at.should eq(@updated_at)
          end

          it { response.should render_template(:edit) }
        end
      end
    end
  end

end