Genesis::Application.routes.draw do

  scope "admin" do
    devise_for :users, :controllers => {:sessions => "admin/users/sessions"}
  end

  namespace "admin" do
    resources :versions, :only => [] do
      member { post :revert }
    end

    resources :templates, :only => %w(show new create edit update) do
      resources :fields, :only => %w(index create)
    end

    resources :fields, :only => %w(destroy)

    resource :theme, :only => %w(show)

    root :to => "pages#dashboard"
  end

end