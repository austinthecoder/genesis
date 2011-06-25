module Admin
  class TemplatesController < BaseController

    before_filter :build_template, :only => %w(new create)
    before_filter :find_template, :only => %w(edit update destroy)
    before_filter :assign_templates, :only => %w(new create edit update destroy)

    def new
    end

    def create
      @tpl.save!
      redirect_to edit_admin_template_url(@tpl), :notice => "Wowza weeza! Template was created!"
    rescue ActiveRecord::RecordInvalid
      flash.alert = "Houston, we have some problems."
      render :new
    end

    def edit
    end

    def update
      @tpl.update_attributes!(params[:template])
      redirect_to edit_admin_template_url(@tpl), :notice => "Template was saved."
    rescue ActiveRecord::RecordInvalid
      flash.alert = "Houston, we have some problems."
      render :edit
    end

    def destroy
      @tpl.destroy!
      undo_link = view_context.button_to("Undo", revert_admin_version_path(@tpl.versions.scoped.last))
      redirect_to admin_theme_url, :notice => "Template was removed. #{undo_link}"
    end

    private

    def find_template
      @tpl = templates_scope.find(params[:id])
    end

    def build_template
      @tpl = templates_scope.build(params[:template])
    end

  end
end