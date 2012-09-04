
class PagesController

  def view_by_month
    @tasks = Event.all
    @calendar_year = params[:year] || DateTime.now.year
    @calendar_month = params[:month] || DateTime.now.month
    @date_group = DateTime.new(@calendar_year.to_i, @calendar_month.to_i, 1).strftime("%B, %Y")
  end

  def view_by_week
    @events = Event.all
    @starting_day = DateTime.now
    @date_group = DateTime.now.strftime("the week of %d/%m/%Y")
  end

end