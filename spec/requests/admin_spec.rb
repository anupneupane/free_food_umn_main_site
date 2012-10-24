require 'spec_helper'

describe "Admin page" do

  before do
    Admin.delete_all
    Event.delete_all
  end
  it { Admin.all.count.should == 0 }
  it { Event.all.count.should == 0 }

  describe "creating admin and event via command line" do
  
    it { Admin.where(email: "admin2@gmail.com").count.should == 0 }
    before do
      Admin.create(:email => "admin1@gmail.com",
                   :password => "Adminpassword2",
                   :password_confirmation => "Adminpassword2")
  
      Event.create(name: "title",
                    description: "New event",
                    date_string: "2012-1-11",
                    start_time_string: "10:10",
                    meridian_indicator: "pm",
                    duration: "2:20",
                    google_maps_url: 'http://maps.google.com',
                    location: "coffman")
    end
    it { Admin.where(email: "admin1@gmail.com").count.should == 1 }
  
    describe "log in" do
  
      before do
        visit '/admin'
      end
  
      it do
        page.should have_selector('h2', text: 'Sign in')
      end
  
      describe "logging in" do
        before do
          fill_in "admin_email", with: "admin1@gmail.com"
          fill_in "admin_password", with: "Adminpassword2"
          click_button "Sign in"
          visit '/admin'
        end
        it "should be logged in" do
          page.should have_selector("h1", text: "Listing events")
        end

        describe "editing an event" do
          before do
            click_link "Edit"
            fill_in "event_date_string", with: "2015-3-15"
            fill_in "event_start_time_string", with: "11:15"
            choose 'event_meridian_indicator_pm'
            fill_in "event_duration", with: "3:15"
            click_button "Submit Event"
          end
          it "Event should be changed" do
            event = Event.first
            event.date.should == DateTime.parse('15th Mar 2015 11:15:00 PM')
            event.end_date.should == DateTime.parse('16th Mar 2015 02:30:00 AM')
          end
        end
        #javascript tests are unfortunately not working as of now
        #describe "click approve event", :js => true do
        #  it { Event.where(:approved_by_admin => true).count.should == 0 }
        #
        #  it do
        #    page.execute_script("$('.admin_approve_event').click()")
        #    Event.where(:approved_by_admin => true).count.should == 1
        #  end
        #end
      end
    end
  
  end


end
