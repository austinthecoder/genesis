require 'spec_helper'

describe Admin::VersionsController do

  before do
    @user = Factory(:user)
    sign_in :user, @user
    @params = HashWithIndifferentAccess.new
  end

  describe "POST revert" do
    context "when the id matches a version with the 'destroy' event" do
      context "when the id matches a version of the 'Field' item_type" do
        before do
          @field = Factory(:field)
          @field.destroy
          @version = @field.versions.scoped.last

          post :revert, :id => @version.id
        end

        it { flash.notice.should eq("Field was added back.") }
        it { response.should redirect_to(admin_template_fields_url(@field.template)) }

        it "restores the field" do
          Field.find(@field.id).should eq(@field)
        end
      end

      context "when the id matches a version of the 'Template' item_type" do
        before do
          @tpl = Factory(:template)
          @tpl.destroy
          @version = @tpl.versions.scoped.last

          post :revert, :id => @version.id
        end

        it { flash.notice.should eq("Template was added back.") }
        it { response.should redirect_to(admin_theme_url) }

        it "restores the template" do
          Template.find(@tpl.id).should eq(@tpl)
        end
      end

      context "when the id matches a version of the 'Page' item_type" do
        before do
          @page = Factory(:page)
          @page.destroy
          @version = @page.versions.scoped.last

          post :revert, :id => @version.id
        end

        it { flash.notice.should eq("Page was added back.") }
        it { response.should redirect_to(admin_pages_url) }

        it "restores the page" do
          Page.find(@page.id).should eq(@page)
        end
      end
    end

    context "when the id doesn't match a version with the 'destroy' event"
  end

end