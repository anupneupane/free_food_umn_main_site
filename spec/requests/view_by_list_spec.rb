require "spec_helper"

class EventStub
  attr_accessor :date
  def initialize date
    @date = date
  end
  #override == so I can feel like I'm somebody/a guy who puts "rubyist" under twitter description
  def == other_event
    @date == other_event.date
  end
end


describe "view by list" do

  let(:right_now) { DateTime.now }

  describe "date_view_controller internals" do
    let(:date_view_controller) { DateViewController.new }

    describe "get_event_closed_to_today internal function" do
      it do
        events = [
          EventStub.new(right_now - 1),
          EventStub.new(right_now - 2),
          EventStub.new(right_now + 1),
          EventStub.new(right_now + 2),
        ]
        date_view_controller.send(:get_event_closed_to_today, events).should == 2
      end
  
      it do
        events = [
          EventStub.new(right_now + (1/60.0)),
          EventStub.new(right_now - 1),
          EventStub.new(right_now - 2),
          EventStub.new(right_now + 1),
          EventStub.new(right_now + 2),
        ]
        date_view_controller.send(:get_event_closed_to_today, events).should == 0
      end
  
      it do
        events = [
          EventStub.new(right_now - 1),
          EventStub.new(right_now - 2),
          EventStub.new(right_now + 1),
          EventStub.new(right_now + 2),
          EventStub.new(right_now + (1/60.0)),
        ]
        date_view_controller.send(:get_event_closed_to_today, events).should == 4
      end
    end

    describe "get_events_that_havent_happened_yet internal function" do
      it do
        events = [
          EventStub.new(right_now + (1/60.0)),
          EventStub.new(right_now - 1),
          EventStub.new(right_now - 2),
          EventStub.new(right_now + 1),
          EventStub.new(right_now + 2),
        ]
        date_view_controller.send(:get_events_that_havent_happened_yet, events, 2).should == [
          EventStub.new(right_now + (1/60.0)),
          EventStub.new(right_now + 1),
        ]
      end

      it do
        events = [
          EventStub.new(right_now - 1),
          EventStub.new(right_now - 2),
          EventStub.new(right_now + 1),
          EventStub.new(right_now + 2),
          EventStub.new(right_now + (1/60.0)),
        ]
        date_view_controller.send(:get_events_that_havent_happened_yet, events, 50).should == [
          EventStub.new(right_now + (1/60.0)),
          EventStub.new(right_now + 1),
          EventStub.new(right_now + 2),
        ]
      end
    end
  end

  describe "list view" do
    before do
      hour = 60 * 60
      date = DateTime.now + hour - 5 * 25 * hour
      (0..75).each do |k|
        title = "title#{k}"
        Event.create!(name: title,
                      description: "New event#{k}",
                      date_string: "#{date.strftime("%m/%d/%Y")}",
                      start_time_string: "#{date.strftime("%l:%M")}",
                      meridian_indicator: "#{date.strftime("%P")}",
                      duration: "2:20",
                      google_maps_url: 'http://maps.google.com',
                      location: "coffman")
        event = Event.where(name: title).first
        event.update_column(:approved_by_admin, true)
        date += 5 * hour
      end
      visit '/view_by_list'
    end

    it { page.html.should =~ /.*img.*src.*right-arrow.png.*/ }
    it { page.html.should =~ /.*img.*src.*left-arrow.png.*/ }

    it "should not have title" do
      page.should_not have_selector("a", text: "title0")
    end

    it "should not have title" do
      page.should_not have_selector("a", text: "title24")
    end

    it "should not have title" do
      page.should_not have_selector("a", text: "title56")
    end

    it { page.should have_selector("a", text: "title25") }
    it { page.should have_selector("a", text: "title32") }
    it { page.should have_selector("a", text: "title41") }
    it { page.should have_selector("a", text: "title54") }

    describe "page left" do
      before do
        click_link "left_arrow"
      end
      it { page.html.should =~ /.*img.*src.*left-arrow-unclickable.png.*/ }
      it { page.html.should =~ /.*img.*src.*right-arrow.png.*/ }

      it "should not have title" do
        page.should_not have_selector("a", text: "title31")
      end

      it "should not have title" do
        page.should_not have_selector("a", text: "title46")
      end

      it "should not have title" do
        page.should_not have_selector("a", text: "title75")
      end

      it { page.should have_selector("a", text: "title0") }
      it { page.should have_selector("a", text: "title11") }
      it { page.should have_selector("a", text: "title21") }
      it { page.should have_selector("a", text: "title24") }

      describe "page right" do
        before do
          click_link "right_arrow"
          click_link "right_arrow"
        end
        it { page.html.should =~ /.*img.*src.*left-arrow.png.*/ }
        it { page.html.should =~ /.*img.*src.*right-arrow-unclickable.png.*/ }

        it "should not have title" do
          page.should_not have_selector("a", text: "title0")
        end

        it "should not have title" do
          page.should_not have_selector("a", text: "title25")
        end

        it "should not have title" do
          page.should_not have_selector("a", text: "title54")
        end

        it "should not have title" do
          page.should_not have_selector("a", text: "title52")
        end

        it { page.should have_selector("a", text: "title56") }
        it { page.should have_selector("a", text: "title57") }
        it { page.should have_selector("a", text: "title67") }
        it { page.should have_selector("a", text: "title75") }
      end
    end
  end

end