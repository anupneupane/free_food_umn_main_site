require "spec_helper"

describe "Weekview" do

  describe "current date" do
    describe "not admin-approved" do
      before do
        Event.create!(name: "not admin-approved",
                      description: "New event",
                      date_string: "#{DateTime.now.month}/#{DateTime.now.day}/#{DateTime.now.year}",
                      start_time_string: "10:10",
                      meridian_indicator: "pm",
                      duration: "2:20",
                      google_maps_url: 'http://maps.google.com',
                      location: "coffman")
        visit "/view_by_week"
      end
    
      it "Event created" do
        Event.first.date.month.should == DateTime.now.month
      end
    
      it "event shows up" do
        page.should_not have_selector("a", text: "not admin-approved")
      end
    end

    describe "admin-approved" do
      before do
        Event.create!(name: "admin-approved",
                      description: "New event",
                      date_string: "#{DateTime.now.month}/#{DateTime.now.day}/#{DateTime.now.year}",
                      start_time_string: "10:10",
                      meridian_indicator: "pm",
                      duration: "2:20",
                      google_maps_url: 'http://maps.google.com',
                      location: "coffman")
        event = Event.where(name: "admin-approved").first
        event.update_column(:approved_by_admin, true)
        visit "/view_by_week"
      end
    
      it "Event created" do
        Event.first.date.month.should == DateTime.now.month
      end
    
      it "event shows up" do
        page.should have_selector("a", text: "admin-approved")
      end

    end
  end

end
