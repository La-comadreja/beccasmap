class Event < ActiveRecord::Base
  validates_presence_of :category, :datetime, :name, :address, :latitude, :longitude, :link
  validates_length_of :category, :name, :venue, maximum: 100
  validates_length_of :address, maximum: 200
  validates_length_of :link, maximum: 1000
  validates_length_of :description, maximum: 500
  validates_numericality_of :latitude, :longitude
  validates_numericality_of :price, allow_nil: true, greater_than_or_equal_to: 0
  validates_uniqueness_of :name, scope: [:datetime, :latitude, :longitude], case_sensitive: false
end