
class PagesController < ApplicationController

  def home
    @featured_group = Group.first
    @tasks = Event.all
    @calendar_year = params[:year] || DateTime.now.year
    @calendar_month = params[:month] || DateTime.now.month
    @month_and_year = DateTime.new(@calendar_year.to_i, @calendar_month.to_i, 1).strftime("%B, %Y")
  end

end
