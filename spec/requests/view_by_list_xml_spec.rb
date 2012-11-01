require 'spec_helper'

describe "view by list xml" do
  before do
    current_time = DateTime.now
    Event.create!(name: "title",
                  description: "New event",
                  date_string: "01/11/#{current_time.year+1}",
                  start_time_string: "10:10",
                  meridian_indicator: "pm",
                  duration: "2:20",
                  google_maps_url: 'http://maps.google.com',
                  location: "coffman")
    event = Event.where(name: "title").first
    event.update_column(:approved_by_admin, true)
    Event.create!(name: "title2",
                  description: "New event2",
                  date_string: "01/15/#{current_time.year+1}",
                  start_time_string: "11:10",
                  meridian_indicator: "pm",
                  duration: "2:20",
                  google_maps_url: 'http://maps.google.com',
                  location: "coffman")
    event = Event.where(name: "title2").first
    event.update_column(:approved_by_admin, true)
  end

  it do
    Event.all.count.should == 2
  end

  it do
    Event.first.date.year.should > DateTime.now.year
  end

  describe "visit url" do
    before do
      visit '/view_by_list/xml'
    end

    it do
      event1 = Event.where(name: "title").first
      page.should have_xpath("//events/event/name", :text => "title")
      page.should have_xpath("//events/event/description", :text => "New event")
      page.should have_xpath("//events/event/date", :text => "#{event1.date}")
      page.should have_xpath("//events/event/end_date", :text => "#{event1.end_date}")
    end


    it { Event.where(name: "title2").count.should == 1 }
    it { Event.where(name: "title2").first.date.year.should > DateTime.now.year }
    it { Event.where(name: "title2").first.approved_by_admin.should == true }
    it do
      event2 = Event.where(name: "title2").first
      page.should have_xpath("//events/event/name", :text => "title2")
      page.should have_xpath("//events/event/description", :text => "New event2")
      page.should have_xpath("//events/event/date", :text => "#{event2.date}")
      page.should have_xpath("//events/event/end_date", :text => "#{event2.end_date}")
    end
  end

end
