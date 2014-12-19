class Event < ActiveRecord::Base
  validates_presence_of :category, :datetime, :name, :address, :link
end