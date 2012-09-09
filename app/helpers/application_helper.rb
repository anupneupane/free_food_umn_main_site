module ApplicationHelper
  def menu menu_items
    render 'shared/menu', :menu_items => menu_items
  end



#<% if @event.location.nil? and not @event.google_maps_url.nil? %>
#  <p><%= link_to("google maps", raw(@event.google_maps_url)) %></p>
#<% elsif not @event.location.nil? and not @event.google_maps_url.nil? %>
#  <p><%= link_to(@event.location, raw(@event.google_maps_url)) %></p>
#<% elsif not @event.location.nil? and @event.google_maps_url.nil? %>
#  <p>location: <%= @event.location %></p>
#<% end %>
  def best_html_if_maybe_location_and_maybe_google_maps_url location_exists, google_maps_url_exists,
                                                            location, google_maps_url
    render 'shared/best_html_if_maybe_location_and_maybe_google_maps_url',
      location_exists: location_exists, google_maps_url_exists: google_maps_url_exists,
      location: location, google_maps_url: google_maps_url
  end

  def format_hours date
    return date.strftime("%l:%M %P")
  end

  def flexible_line_height_link_to text, href
    render partial: 'shared/paragraph_hyper_link', locals: { href: href, text: text }
  end

  def next_month month
    month_adjusted_for_modulous = month - 1
    month_adjusted_for_modulous += 1
    month_adjusted_for_modulous_mod = month_adjusted_for_modulous % 12
    return month_adjusted_for_modulous_mod + 1
  end

  def previous_month month
    month_adjusted_for_modulous = month - 1
    month_adjusted_for_modulous -= 1
    month_adjusted_for_modulous = 11 if month_adjusted_for_modulous < 0
    month_adjusted_for_modulous_mod = month_adjusted_for_modulous % 12
    return month_adjusted_for_modulous_mod + 1
  end

  def next_months_year month, year
    month == 12 ? year + 1 : year
  end


  def previous_months_year month, year
    month == 1 ? year - 1 : year
  end

end
