class Admin::TemplatesController < ApplicationController

  def new
    @tpl = Template.new
  end

  def create
    Template.create!(params[:template])
    flash.notice = "Wowza weeza! Template was created!"
    redirect_to admin_templates_url
  end

end