class Admin::VersionsController < AdminController

  def revert
    version = Version.where(:event => "destroy").find(params[:id])

    case version.item_type
    when 'Field'
      if field = version.reify
        field.save!
        flash.notice = "Field was added back."
        redirect_to admin_template_fields_url(field.template)
      end
    when 'Template'
      if template = version.reify
        template.save!
        flash.notice = "Template was added back."
        redirect_to admin_theme_url
      end
    when 'Page'
      if page = version.reify
        page.save!
        flash.notice = "Page was added back."
        redirect_to admin_pages_url
      end
    end
  end

end