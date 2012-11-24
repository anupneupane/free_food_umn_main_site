
class DateViewController < DateViewAndUiController

  before_filter :set_events_var, :only => [:view_by_month, :view_by_week, :view_by_list, :view_by_list_xml, :mobile]

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

    closest_to_today = get_event_closed_to_today(@events)

    @n = params[:n] || 0
    offset = @n ? number_of_events_per_page * @n.to_i : 0
    right_offset = @n ? number_of_events_per_page * (@n.to_i + 1) : 0

    if closest_to_today.nil?
      @show_left_arrow = false
      @show_right_arrow = false
    else
      @show_left_arrow = (closest_to_today + offset < 1) ? false : true
      @show_right_arrow = ((closest_to_today + right_offset) > @events.length - 2) ? false : true
    end

    @events = get_events_that_havent_happened_yet @events, number_of_events_per_page, offset
    render 'events/mobile', :layout => false
    return false
  end

  def view_by_list
    @page = params[:n].to_i

    event_vars = ListView.organization_events_by_day(
      events: @events,
      today: DateTime.now,
      page: @page,
      events_per_page: 30,
      date_format: "%B, %d")

    @event_date_groups = event_vars[:events]
    @show_left_arrow = (event_vars[:leftmost_page] == 0 ? false : true)
    @show_right_arrow = (event_vars[:rightmost_page] == 0 ? false : true)
  end

  def view_by_list_xml
    @events = ListView.get_events(events: @events, events_per_page: 30, page: 0)
    render 'view_by_list', formats: [:xml]
  end

  private
    def set_events_var
      @events_of_approved_organizations = Event.all(:joins => :organization, :conditions => { :organizations => { :approved_by_admin => true } })
      @approved_events = Event.where(:approved_by_admin => true).all
      @events = @events_of_approved_organizations + @approved_events
    end

end
