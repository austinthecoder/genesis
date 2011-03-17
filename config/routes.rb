Genesis::Application.routes.draw do

  scope "admin" do
    devise_for :users, :controllers => {:sessions => "admin/users/sessions"}
  end

  namespace "admin" do
    resources :versions, :only => [] do
      member { post :revert }
    end

    resources :pages, :only => %w(index new create show edit update destroy) do
      member { get :edit_template }

      resources :pages, :only => %w(new create)
    end

    resources :templates, :only => %w(new create edit update destroy) do
      resources :fields, :only => %w(index create)
    end

    resources :fields, :only => %w(destroy edit update)

    resource :theme, :only => %w(show)

    root :to => "dashboard#index"
  end

end