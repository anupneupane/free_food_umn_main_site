
class PagesController < ApplicationController

  def home
    @featured_group = Group.first
    @tasks = Event.all
  end

end
