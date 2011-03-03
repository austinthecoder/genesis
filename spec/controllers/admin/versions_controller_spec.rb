require 'spec_helper'

describe Admin::VersionsController do

  before(:all) { @user = Factory(:user) }

  before do
    sign_in :user, @user
    @params = HashWithIndifferentAccess.new
  end

  describe "POST revert" do
    before do
      @tpl = Factory(:template)
      @field = Factory(:field, :template => @tpl)
      @field.destroy
      @version = @field.versions.scoped.last
    end

    context "when the id matches a version of the 'Field' item_type and 'destroy' event" do
      before { post :revert, :id => @version.id }

      it { flash[:notice].should eq("Field was added back.") }
      it { response.should redirect_to(admin_template_fields_url(@tpl)) }

      it "restores the field" do
        Field.find(@field.id).should eq(@field)
      end
    end
  end

end