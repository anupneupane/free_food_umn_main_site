class Event < ActiveRecord::Base

  cattr_accessor :date_string, :meridian_indicator, :duration, :start_time_string

  attr_accessible :name, :description, :meridian_indicator,
                  :google_maps_url, :group_url, :date_string,
                  :duration, :start_time_string,
                  :location, :group_name, :long_description

  VALID_DATE_STRING_REGEX = /\d{4,4}-\d{1,2}-\d{2,2}/i
  validates :date_string, presence: true, format: { with: VALID_DATE_STRING_REGEX }

  VALID_START_TIME_STRING = /\d{1,2}:\d{2,2}/i
  validates :start_time_string, presence: true, format: { with: VALID_START_TIME_STRING }

  VALID_MERIDIAN_INDICATOR = /[(am)(pm)]/i
  validates :meridian_indicator, presence: true, format: { with: VALID_MERIDIAN_INDICATOR }

  VALID_DURATION = /\d{1,2}:\d{2,2}/i
  validates :duration, presence: true, format: { with: VALID_DURATION }

  validates :description, :presence => true
  #validates :location, :presence => true, :unless => "google_maps_url.nil?"

  before_save { |event|
    event.date = starting_date
    event.end_date = ending_date
  }

  def date_string
    @@date_string || (date.nil? ? nil : date.strftime("%Y-%m-%d"))
  end

  def start_time_string
    @@start_time_string || (date.nil? ? nil : date.strftime("%l:%M"))
  end

  def meridian_indicator
    @@meridian_indicator || (date.nil? ? nil : date.strftime("%P"))
  end

  def duration
    def duration_from_database
      seconds = (end_date - date)
      hours = (seconds / (60.0*60)).to_i
      minutes = (seconds - (hours * 60 * 60)).to_i
      if minutes < 10
        minutes = "0#{minutes}"
      end
      "#{hours}:#{minutes}"
    end
    @@duration || (date.nil? or end_date.nil? ? nil : duration_from_database)
  end

  def starting_date
    return DateTime.strptime("#{@@date_string} #{@@start_time_string} #{@@meridian_indicator}", "%Y-%m-%d %l:%M %P")
  end

  def ending_date
    return starting_date + form_entered_time_to_seconds(@@duration)
  end

  private
    def form_entered_time_to_seconds form_entered_time
      hours_and_minutes = form_entered_time.split(':')
      one_minute = (1.0/(24*60))
      return (hours_and_minutes[0].to_i * 60 * one_minute) + (hours_and_minutes[1].to_i * one_minute)
    end
end
