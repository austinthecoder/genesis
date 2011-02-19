Genesis::Application.routes.draw do

  namespace "admin" do
    devise_for :users, :controllers => {:sessions => "admin/users/sessions"}
  end

  # root :to => "admin/"

end