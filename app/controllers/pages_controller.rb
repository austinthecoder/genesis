class PagesController < ApplicationController

  def show
    if page = Page.find_by_request_path("/#{params[:path]}")
      render :text => page.to_html
    end
  end

end