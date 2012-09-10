require 'spec_helper'

describe "when I fill out the new event form" do

  before do
    visit '/events/new'

    fill_in 'event_name', with: 'Example title'
    fill_in 'event_date_string', with: "2012-08-25"
    fill_in 'event_start_time_string', with: '10:00'
    choose 'event_meridian_indicator_am'
    fill_in 'event_duration', with: '5:00'
    fill_in 'event_description', with: 'Chess Club meeting'
    fill_in 'event_location', with: 'coffman'
    fill_in 'event_google_maps_url', with: 'http://maps.google.com'
  end

  it "should increment events and redirect to homepage with a message" do
    expect do
      click_button 'Create Event'
    end.to change(Event, :count).by(1)

    page.should have_selector('div', :class => 'alert alert-info',
      :text => "Thank you for submitting the event! An admin should approve it shortly.")
  end

  describe "and submit event as organization" do
    before do
      click_button 'Submit Event as Organization'
    end

    it { page.should have_selector('a', :text => "Sign up") }

    describe "and create a new organization" do
      before do
        click_link "Sign up"
        fill_in "organization_email", with: "test@test.com"
        fill_in "organization_name", with: "Test Organization"
        fill_in "organization_password", with: "asdAsd123q"
        fill_in "organization_password_confirmation", with: "asdAsd123q"
        click_button "Sign up"
      end

      it do
        page.should have_selector('div', :class => 'alert alert-info',
        :text => "Thank you for submitting the event! An admin should approve it shortly.")
      end

      it { Event.count.should == 1 }

      it { Event.first.group_name.should == "Test Organization" }

    end
  end

end
