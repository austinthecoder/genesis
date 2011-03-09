class Admin::VersionsController < AdminController

  def revert
    if field = Version.where(:item_type => "Field", :event => "destroy").find(params[:id]).reify
      field.save!
      flash.notice = "Field was added back."
      redirect_to admin_template_fields_url(field.template)
    end
  end

end