require 'spec_helper'

describe "Events" do
  describe "creating an event" do
    before {
      group = FactoryGirl.create(:group)
    }
    it "creating event works" do
      Group.all.count.should == 1

      visit '/events/new'
      #response.should be_success
      
      fill_in 'event_name', with: 'Example title'
      fill_in 'event_date_string', with: "2012-08-25"
      fill_in 'event_start_time_string', with: '10:00'
      choose 'event_meridian_indicator_am'
      fill_in 'event_duration', with: '5:00'
      fill_in 'event_description', with: 'Chess Club meeting'
      
      expect do
        click_button 'Create Event'
      end.to change(Event, :count).by(1)

    end
  end
end
