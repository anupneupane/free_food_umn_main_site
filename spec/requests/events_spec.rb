require 'spec_helper'

describe "when I fill out the new event form" do

  before do
    visit '/events/new'

    fill_in 'event_name', with: 'Example title'
    fill_in 'event_date_string', with: Time.now.strftime("%m/%d/%Y")
    fill_in 'event_start_time_string', with: '10:00'
    choose 'event_meridian_indicator_am'
    fill_in 'event_duration', with: '5:00'
    fill_in 'event_description', with: 'Chess Club meeting'
    fill_in 'event_location', with: 'coffman'
    fill_in 'event_google_maps_url', with: 'http://maps.google.com'
    fill_in 'event_long_description', with: "sample \n long description"
  end

  describe "show event" do
    before do
      click_button 'Submit Event'
      visit "/events/#{event.id}"
    end
    let(:event) do
      Event.where(name: "Example title").first
    end
    it "long description should be line breaked properly" do
      page.should have_selector("br")
    end
  end

  it "should increment events and redirect to homepage with a message" do
    expect do
      click_button 'Submit Event'
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
        fill_in "organization_url", with: "http://www.test-url.com"
        click_button "Sign up"
      end

      it { Organization.count.should == 1 }

      it do
        page.should have_selector('div', :class => 'alert alert-info',
        :text => "Thank you for submitting the event! An admin should approve it shortly.")
      end

      it { Event.count.should == 1 }

      it { Event.first.organization.name.should == "Test Organization" }

      describe "if organization admin-approved" do
        before do
          organization = Organization.first
          organization.update_attribute(:approved_by_admin, true)
        end

        it { Organization.first.approved_by_admin.should == true }

        it do
          visit '/view_by_week'
          page.should have_selector('p', :text => 'Chess Club meeting')
        end

        describe "view event's profile" do
          let(:url_array) do
            visit '/view_by_week'
            url_of_event = page.html.match(/<a href="(.*)">Example title<\/a>/)[1]
            unless url_of_event.nil?
              visit url_of_event
            end
            page.html.match(/<a href="(.*)">Test Organization<\/a>/)
          end

          it "organization url" do
            url_array[1].should == "http://www.test-url.com"
          end
        end

      end

      describe "if organization not admin-approved" do
        it do
          visit '/view_by_week'
          page.should_not have_selector('p', :text => 'Chess Club meeting')
        end

        it do
          id = Event.first.id
          visit "/events/#{id}"
          page.should_not have_selector('p', :text => "By: Test Organization")
        end
      end

    end
  end

end
