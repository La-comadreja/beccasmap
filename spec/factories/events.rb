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
  
  factory :event2, class: Event do
    category "Professional Development"
    datetime "2014-10-02 19:00:00"
    name "Problem Solving Practice for Coders"
    venue "Dress for Success Hudson County"
    address "121 Newark Avenue, Jersey City"
    link "http://www.dressforsuccess.org/affiliate.aspx?sisid=32&pageid=3"
    price "10.00"
    description "Business casual is a somewhat baffling phrase to the uninitiated. Is it businesswear, or is "
  end
end