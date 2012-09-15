
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
    @date_group = params[:year].nil? ? 'events this week' : @starting_day.strftime("week of %_m/%d/%Y")
  end

  def mobile
    number_of_events_per_page = 30
    @events.sort_by! {|event| event.date}
    closest_to_today = get_event_closed_to_today @events
    @show_left_arrow = ((closest_to_today - number_of_events_per_page*(params[:n]).to_i) < 1) ? false : true
    @show_right_arrow = ((closest_to_today + number_of_events_per_page*(params[:n]).to_i) > @events.length - 2) ? false : true

    start_event_index = [closest_to_today - number_of_events_per_page*(params[:n]).to_i, 0].max
    end_event_index = [start_event_index + number_of_events_per_page, @events.length-1].min
    @events = @events[start_event_index, end_event_index]
    render 'events/mobile', :layout => false
    return false
  end

  private
    def set_events_var
      @events_of_approved_organizations = Event.all(:joins => :organization, :conditions => { :organizations => { :approved_by_admin => true } })
      @approved_events = Event.where(:approved_by_admin => true).all
      @events = @events_of_approved_organizations + @approved_events
      mobile if is_mobile_device?
    end

    def get_event_closed_to_today events
      today = DateTime.now
      closest_to_today = 0
      closest_to_today_event = events[0]
      events.each_with_index do |event, index|
        if (event.date - today).abs < (closest_to_today_event.date - today).abs
          closest_to_today = index
          closest_to_today_event = event
        end
      end
      return closest_to_today
    end

end
