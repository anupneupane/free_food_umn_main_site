class Event < ActiveRecord::Base
  attr_accessible :name, :description, :meridian_indicator,
                  :google_maps_url, :group_url, :date_string,
                  :duration, :start_time_string,
                  :location, :meal_type, :group_name

  cattr_accessor :date_string, :meridian_indicator, :duration,
                :google_maps_url, :group_url, :start_time_string,
                :location, :meal_type, :group_name

  before_save { |event|
    event.date = starting_date
    event.end_date = ending_date
  }

  def starting_date
    return DateTime.strptime("#{date_string} #{start_time_string} #{meridian_indicator}", "%Y-%m-%d %l:%M %P")
  end

  def ending_date
    return starting_date + form_entered_time_to_seconds(duration)
  end

  private
    def form_entered_time_to_seconds form_entered_time
      hours_and_minutes = form_entered_time.split(':')
      one_minute = (1.0/(24*60))
      return (hours_and_minutes[0].to_i * 60 * one_minute) + (hours_and_minutes[1].to_i * one_minute)
    end
end
