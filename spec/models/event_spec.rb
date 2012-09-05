require 'spec_helper'


def form_entered_time_to_seconds form_entered_time
  hours_and_minutes = form_entered_time.split(':')
  one_minute = (1.0/(24*60))
  return (hours_and_minutes[0].to_i * 60 * one_minute) + (hours_and_minutes[1].to_i * one_minute)
end


describe Event do

  describe "should be able to create an event with valid data" do
    before do
      Event.create!(name: "title",
                    description: "New event",
                    date_string: "2012-1-11",
                    start_time_string: "10:10",
                    meridian_indicator: "pm",
                    duration: "2:20",
                    group_url: "http://www.test.com",
                    google_maps_url: 'http://maps.google.com')
    end

    it { Event.all.count.should == 1 }
    let(:event) { Event.find_by_name("title") }
    it { event.description.should == "New event" }
    it { (event.end_date - event.date).should == 60*60 * (2 + 2.0/6) }
    it { event.date.strftime("%_m/%d/%Y %l:%M %P").strip.should == "1/11/2012 10:10 pm" }
    it { event.group_url.should == "http://www.test.com" }
    it { event.google_maps_url.should == 'http://maps.google.com' }
  end

  describe "should be able to create an event with valid data the long way" do
    before do
      Event.delete_all
      event = Event.new
      event.name = "title"
      event.description = "New event"
      event.date_string = "2012-1-11"
      event.start_time_string = "10:10"
      event.meridian_indicator =  "pm"
      event.duration = "2:20"
      event.group_url = "http://www.test.com"
      event.google_maps_url = 'http://maps.google.com'
      event.save
    end
  
    it { Event.all.count.should == 1 }
    let(:event) { Event.find_by_name("title") }
    it { event.description.should == "New event" }
    it { (event.end_date - event.date).should == 60*60 * (2 + 2.0/6) }
    it { event.date.strftime("%_m/%d/%Y %l:%M %P").strip.should == "1/11/2012 10:10 pm" }
    it { event.group_url.should == "http://www.test.com" }
    it { event.google_maps_url.should == 'http://maps.google.com' }
  end

end
