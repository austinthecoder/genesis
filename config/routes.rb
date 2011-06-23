Genesis::Application.routes.draw do

  scope "admin" do
    devise_for :users,
      :controllers => {
        :sessions => "admin/users/sessions",
        :registrations => "admin/users/registrations"
      }
  end

  namespace "admin" do
    resources :versions, :only => [] do
      member { post :revert }
    end

    resources :pages, :except => %w(show) do
      member { get :edit_template }

      resources :pages, :only => %w(new create)
    end

    resources :templates, :except => %w(index show) do
      resources :fields, :only => %w(index create)
    end

    resources :fields, :only => %w(destroy edit update)

    resource :theme, :only => %w(show)

    root :to => "dashboard#index"
  end

  root :to => 'pages#show'
  match '*path' => 'pages#show'

end