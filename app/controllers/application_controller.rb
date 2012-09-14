class ApplicationController < ActionController::Base
  protect_from_forgery
  has_mobile_fu
  #for devise
  def after_sign_in_path_for(resource)
    if session[:stored_params].nil?
      root_path
    else
      '/create_event'
    end
  end
end
