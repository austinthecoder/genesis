class Admin::Users::SessionsController < Devise::SessionsController

  layout 'admin_login'

  def after_sign_in_path_for(resource)
    admin_root_url
  end

  def after_sign_out_path_for(resource)
    new_user_session_url
  end

end