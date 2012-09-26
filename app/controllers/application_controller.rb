class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    if is_mobile_device?
      redirect_to "/mobile"
    else
      redirect_to "/view_by_week"
    end
  end

  #for devise
  def after_sign_in_path_for(resource)
    if session[:stored_params].nil?
      root_path
    else
      '/create_event'
    end
  end
end
