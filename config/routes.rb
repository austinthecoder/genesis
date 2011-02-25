Genesis::Application.routes.draw do

  scope "admin" do
    devise_for :users, :controllers => {:sessions => "admin/users/sessions"}
  end

  namespace "admin" do
    resources :templates, :only => %w(index new create)

    resource :theme, :only => %w(show)

    root :to => "pages#dashboard"
  end

end