FactoryGirl.define do
  factory :event do
    category "Technology"
    datetime "2014-10-02 19:00:00"
    name "Problem Solving Practice for Coders"
    venue "Indiegrove Coworking Space"
    address "121 Newark Avenue, Jersey City"
    link "http://www.meetup.com/problemsolving/events/208643242/"
    price "0.00"
    description "Book Club! Review arrays, strings and sorting Chapter 1"
  end
end
