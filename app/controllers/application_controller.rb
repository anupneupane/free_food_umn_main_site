class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_vars
  def set_vars
    @featured_group = Group.first
  end
end
