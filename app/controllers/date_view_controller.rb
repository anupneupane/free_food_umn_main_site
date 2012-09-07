
class DateViewController < DateViewAndUiController

  def view_by_month
    @events = Event.where(:approved_by_admin => true)
    @calendar_year = (params[:year] || DateTime.now.year).to_i
    @calendar_month = (params[:month] || DateTime.now.month).to_i
    @date_group = DateTime.new(@calendar_year, @calendar_month, 1).strftime("%B, %Y")
  end

  def view_by_week
    @events = Event.where(:approved_by_admin => true)
    year = (params[:year] || DateTime.now.year).to_i
    month = (params[:month] || DateTime.now.month).to_i
    day = (params[:day] || DateTime.now.day).to_i
    @starting_day = DateTime.new(year, month, day)
    @date_group = @starting_day.strftime("the week of %_m/%d/%Y")
  end

end
