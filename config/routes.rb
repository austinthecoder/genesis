Genesis::Application.routes.draw do

  namespace "admin" do
    devise_for :users, :controllers => {:sessions => "admin/users/sessions"}

    resources :templates, :only => %w(index new create)
  end

  root :to => "admin/pages#dashboard"

end