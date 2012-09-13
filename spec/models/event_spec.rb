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
                    google_maps_url: 'http://maps.google.com',
                    location: "coffman")
      Event.find_by_name("title")
    end

    #it { Event.all.count.should == 1 }
    it { event.description.should == "New event" }
    it { (event.end_date - event.date).should == 60*60 * (2 + 2.0/6) }
    it { event.date.strftime("%_m/%d/%Y %l:%M %P").strip.should == "1/11/2012 10:10 pm" }
    it { event.google_maps_url.should == 'http://maps.google.com' }
    it { event.approved_by_admin.should == false }
    it { event.location.should == "coffman" }

    it "event.attributes works" do
        event_hash = {
          "name"=>"title",
          "description"=>"New event",
          "google_maps_url"=>'http://maps.google.com',
          "approved_by_admin"=>false,
          "location"=>"coffman",
          "long_description"=>nil,
          "organization_id"=>nil,
        }
        event_created = event.attributes
        event_created.delete "id"
        event_created.delete "date"
        event_created.delete "end_date"
        event_created.delete "created_at"
        event_created.delete "updated_at"
        event_created.should == event_hash
    end

    it "should be able to update events" do
      event.update_attributes({name: "title",
                    description: "New event",
                    date_string: "2012-1-11",
                    start_time_string: "10:10",
                    meridian_indicator: "pm",
                    duration: "2:20",
                    google_maps_url: 'http://maps.google.com',
                    location: "different location"})
      event.location.should == "different location"
    end
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
      event.google_maps_url = 'http://maps.google.com'
      event.location = "coffman"
      event.save
      Event.find_by_name("title")
    end
  
    #it { Event.all.count.should == 1 }
    it { event.description.should == "New event" }
    it { (event.end_date - event.date).should == 60*60 * (2 + 2.0/6) }
    it { event.date.strftime("%_m/%d/%Y %l:%M %P").strip.should == "1/11/2012 10:10 pm" }
    it { event.google_maps_url.should == 'http://maps.google.com' }
    it { event.approved_by_admin.should == false }
    it { event.location.should == "coffman" }
  end

  describe "invalid data" do

    it "invalid date_string, start_time_string, ... date-related" do
      expect {
        Event.create(name: "title",
                      description: "New event",
                      date_string: "asd",
                      start_time_string: "asd",
                      meridian_indicator: "122",
                      duration: "1232",
                      google_maps_url: 'http://maps.google.com',
                      location: "coffman")
      }.to change { Event.count }.by(0)
    end

    it "should be invalid if google_maps_url is given without location" do
      expect {
        Event.create(description: "New event",
                      date_string: "2012-1-11",
                      start_time_string: "10:10",
                      meridian_indicator: "pm",
                      duration: "2:20",
                      google_maps_url: 'http://maps.google.com')
      }.to change { Event.count }.by(0)
    end

    it "should be invalid" do
      expect {
        Event.create(date_string: "2012-1-11",
                      start_time_string: "10:10",
                      meridian_indicator: "pm",
                      duration: "2:20")
      }.to change { Event.count }.by(0)
    end
  end

end
