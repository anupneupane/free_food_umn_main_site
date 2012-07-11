class Event < ActiveRecord::Base
  attr_accessible :date, :description, :end_date, :name
end
