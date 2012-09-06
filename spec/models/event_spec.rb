require 'spec_helper'


def form_entered_time_to_seconds form_entered_time
  hours_and_minutes = form_entered_time.split(':')
  one_minute = (1.0/(24*60))
  return (hours_and_minutes[0].to_i * 60 * one_minute) + (hours_and_minutes[1].to_i * one_minute)
end


describe Event do

  describe "should be able to create an event with valid data" do
    let(:event) do
      Event.create!(name: "title",
                    description: "New event",
                    date_string: "2012-1-11",
                    start_time_string: "10:10",
                    meridian_indicator: "pm",
                    duration: "2:20",
                    group_url: "http://www.test.com",
                    google_maps_url: 'http://maps.google.com',
                    location: "coffman",
                    meal_type: "full meal",
                    group_name: "chess club")
      Event.find_by_name("title")
    end

    #it { Event.all.count.should == 1 }
    it { event.description.should == "New event" }
    it { (event.end_date - event.date).should == 60*60 * (2 + 2.0/6) }
    it { event.date.strftime("%_m/%d/%Y %l:%M %P").strip.should == "1/11/2012 10:10 pm" }
    it { event.group_url.should == "http://www.test.com" }
    it { event.google_maps_url.should == 'http://maps.google.com' }
    it { event.approved_by_admin.should == false }
    it { event.location.should == "coffman" }
    it { event.meal_type.should == "full meal" }
    it { event.group_name.should == "chess club" }
  end

  describe "should be able to create an event with valid data the long way" do
    let(:event) do
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
      event.location = "coffman"
      event.meal_type = "full meal"
      event.group_name = "chess club"
      event.save
      Event.find_by_name("title")
    end
  
    #it { Event.all.count.should == 1 }
    it { event.description.should == "New event" }
    it { (event.end_date - event.date).should == 60*60 * (2 + 2.0/6) }
    it { event.date.strftime("%_m/%d/%Y %l:%M %P").strip.should == "1/11/2012 10:10 pm" }
    it { event.group_url.should == "http://www.test.com" }
    it { event.google_maps_url.should == 'http://maps.google.com' }
    it { event.approved_by_admin.should == false }
    it { event.location.should == "coffman" }
    it { event.meal_type.should == "full meal" }
    it { event.group_name.should == "chess club" }
  end

end
