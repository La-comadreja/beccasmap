class Event < ActiveRecord::Base
  validates_presence_of :category, :datetime, :name, :address, :link
  validates_length_of :category, :name, :venue, maximum: 100
  validates_length_of :address, maximum: 200
  validates_length_of :link, maximum: 1000
  validates_length_of :description, maximum: 500
  validate :validate_case_insensitive_uniqueness_of_name_address_datetime
  
  def validate_case_insensitive_uniqueness_of_name_address_datetime
    if name && address && datetime
      query = "LOWER(name) LIKE ? AND LOWER(address) LIKE ? AND datetime=?"
      event = Event.where(query, name.downcase, address.downcase, datetime.to_s(:db)).take
      if event
        self.errors.add(:name, "Combination of event name, address, date and time has already been taken")
      end
    end
  end
end