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

end
