module EventsHelper
  def format_hours date
    return date.strftime("%l:%M %P")
  end
end
