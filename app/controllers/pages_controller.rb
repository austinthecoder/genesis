class PagesController < ApplicationController

  def show
    @page = Page.find_by_request_path("/#{params[:path]}")
  end

end