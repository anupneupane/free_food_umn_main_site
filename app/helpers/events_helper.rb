module EventsHelper
  def format_hours date
    return date.strftime("%I:%M %P")
  end
end
