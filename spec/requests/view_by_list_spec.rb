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

end
