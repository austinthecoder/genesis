module Admin
  module Users
    class RegistrationsController < Devise::RegistrationsController

      layout 'admin'

    end
  end
end