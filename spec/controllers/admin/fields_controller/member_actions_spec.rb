require 'spec_helper'

describe Admin::FieldsController, "member actions" do

  before(:all) { @user = Factory(:user) }

  before do
    sign_in :user, @user
    @tpl = Factory(:template, :user => @user)
    @field = Factory(:field, :template => @tpl)
    @params = HashWithIndifferentAccess.new(
      :template_id => @tpl.id,
      :id => @field.id
    )
  end

  describe "DELETE destroy" do
    context "when the id matches a field belonging to the user" do
      before { delete :destroy, @params }

      it "destroys the field" do
        lambda do
          @field.reload
        end.should raise_error(ActiveRecord::RecordNotFound, "Couldn't find Field with ID=#{@field.id}")
      end

      it "sets a notice with an undo link" do
        path = revert_admin_version_path(@field.versions.scoped.last)
        undo_button = controller.view_context.button_to("Undo", path)
        flash.notice.should eq("Field was removed. #{undo_button}")
      end

      it { response.should redirect_to(admin_template_fields_url(@tpl)) }
    end

    context "when the id does not match a field belonging to the current user" do
      before do
        @params[:id] = 347890
        delete :destroy, @params
      end

      it { response.code.should eq("404") }
      it { response.should render_template("admin/shared/not_found") }
    end
  end

end