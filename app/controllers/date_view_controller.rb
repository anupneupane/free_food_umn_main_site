
class DateViewController < DateViewAndUiController

  before_filter :set_events_var

  def view_by_month
    @calendar_year = (params[:year] || DateTime.now.year).to_i
    @calendar_month = (params[:month] || DateTime.now.month).to_i
    @date_group = DateTime.new(@calendar_year, @calendar_month, 1).strftime("%B, %Y")
  end

  def view_by_week
    year = (params[:year] || DateTime.now.year).to_i
    month = (params[:month] || DateTime.now.month).to_i
    day = (params[:day] || DateTime.now.day).to_i
    @starting_day = DateTime.new(year, month, day)
    @date_group = @starting_day.strftime("the week of %_m/%d/%Y")
  end

  private
    def set_events_var
      @events_of_approved_organizations = Event.all(:joins => :organization, :conditions => { :organizations => { :approved_by_admin => true } })
      @approved_events = Event.where(:approved_by_admin => true).all
      @events = @events_of_approved_organizations + @approved_events
    end

end
