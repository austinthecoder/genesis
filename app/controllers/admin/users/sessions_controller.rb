module Admin
  module Users
    class SessionsController < Devise::SessionsController

      layout 'admin_login'

      before_filter :add_site_id_to_user_params, :only => %w(create)

      def after_sign_in_path_for(resource)
        admin_root_url
      end

      def after_sign_out_path_for(resource)
        new_user_session_url
      end

      private

      def add_site_id_to_user_params
        if params[:user].is_a?(Hash)
          params[:user][:site_id] = Site.find_by_domain(request.host).try(:id)
        end
      end

    end
  end
end