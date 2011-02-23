class Admin::Users::SessionsController < Devise::SessionsController

  layout 'admin'

  def after_sign_in_path_for(resource)
    resource.is_a?(User) ? admin_root_url : super
  end

  # def after_sign_out_path_for
  #
  # end

end