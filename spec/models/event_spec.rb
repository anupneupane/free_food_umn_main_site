require 'spec_helper'


def form_entered_time_to_seconds form_entered_time
  hours_and_minutes = form_entered_time.split(':')
  one_minute = (1.0/(24*60))
  return (hours_and_minutes[0].to_i * 60 * one_minute) + (hours_and_minutes[1].to_i * one_minute)
end

describe Event do

  before do
    @event = Event.new
  end

  subject { @event }

  it { should respond_to(:date) }
  it { should respond_to(:description) }
  it { should be_valid }

  it "new event is created properly" do

    #current_date = Time.now
    #future_date = current_date + 60*60*24*200
    Event.create!(name: "title",
                  description: "New event",
                  date_string: "2012-1-11",
                  start_time_string: "10:10",
                  meridian_indicator: "pm",
                  duration: "2:20")

    Event.all.count.should == 1
    event = Event.find_by_name("title")
    event.description.should == "New event"
    (event.end_date - event.date).should == 60*60 * (2 + 2.0/6)
    event.date.strftime("%_m/%d/%Y %l:%M %P").strip.should == "1/11/2012 10:10 pm"

    Event.delete_all

    event = Event.new
    event.name = "title"
    event.description = "New event"
    event.date_string = "2012-1-11"
    event.start_time_string = "10:10"
    event.meridian_indicator =  "pm"
    event.duration = "2:20"
    event.save

    Event.all.count.should == 1
    event = Event.find_by_name("title")
    event.description.should == "New event"
    (event.end_date - event.date).should == 60*60 * (2 + 2.0/6)
    event.date.strftime("%_m/%d/%Y %l:%M %P").strip.should == "1/11/2012 10:10 pm"
  end

end
