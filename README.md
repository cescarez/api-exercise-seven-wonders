# API Exercise: Seven Wonders of the World

You are planning a trip to see all seven wonders of the world! How exciting! And now you need to plan your trip, using the coordinates of all seven wonders. Being a developer, why do this yourself when you can have a computer do it for you?!  

## Objective

Using the list of all the wonders, make a collection of all their coordinates using httparty and Location IQ's API.

**Use this:**
```ruby
seven_wonders = ["Great Pyramid of Giza", "Gardens of Babylon", "Colossus of Rhodes", "Pharos of Alexandria", "Statue of Zeus at Olympia", "Temple of Artemis", "Mausoleum at Halicarnassus"]
```

**To Generate this:**
```ruby
[{"Great Pyramid of Giza"=>{:lat=>"29.9791264", :lon=>"31.1342383751015"}}, {"Gardens of Babylon"=>{:lat=>"50.8241215", :lon=>"-0.1506162"}}, {"Colossus of Rhodes"=>{:lat=>"36.3397076", :lon=>"28.2003164"}}, {"Pharos of Alexandria"=>{:lat=>"30.94795585", :lon=>"29.5235626430011"}}, {"Statue of Zeus at Olympia"=>{:lat=>"37.6379088", :lon=>"21.6300063"}}, {"Temple of Artemis"=>{:lat=>"32.2818952", :lon=>"35.8908989553238"}}, {"Mausoleum at Halicarnassus"=>{:lat=>"37.03788265", :lon=>"27.4241455276707"}}]
```

## Requirements

### Understand the Scaffold

Open up `seven_wonders.rb` in this repo. What do you see? Answer the following questions with a neighbor.
1. What are the constant variables in this file? What are their values?
1. What are the two methods defined?
1. What is the `find_seven_wonders` method returning?
2. Look this up:
    - What is API rate limiting?
    - What does Ruby's built-in method `sleep` do?
3. Inside of the `find_seven_wonders` method, what happens inside of the `each` loop?

### Sign up for Location IQ

To get access to [Location IQ's](https://my.locationiq.com) API, we need to sign up for a Location IQ key.

Go to their website and create a free account.

Then, find your user dashboard, and look for Geocoding. You'll find a **token** somewhere. Use this token as your Location IQ API Key.

### Implement `get_location`

`get_location` is a method that takes in one `search_term` query and returns a hash in the form of `{ original location name => { :lat => "99.99", :lon => "99.99"}}`

For example, if the passed in `search_term` is `"Great Pyramid of Giza"`, then the output should be

```ruby
{
  "Great Pyramid of Giza"=> {
    :lat=>"29.9791264",
    :lon=>"31.1342383751015"
  }
}
```

Implement this method so it makes a call to Location IQ using HTTParty.

Things to consider:
  - What is the base URL for this call? You will need to look at the Location IQ Geocoding documentation to find the answer.
  - What is the HTTParty syntax to set the query parameters for this call? What needs to be part of the query parameters?
  - What does the response that comes back from the Location IQ API look like? How do we check or verify? What debugging tools can we use?
    - Hint: After discovering what the response from Location IQ looks like, if you see "multiple" coordinates, pick the "first" one.

## Optional Enhancement

For an optional enhancement try to:

- Make a request for driving directions from Cairo Egypt to the Great Pyramid of Giza.  
- Turn these locations into the names of places: `[{ lat: 38.8976998, lon: -77.0365534886228}, {lat: 48.4283182, lon: -123.3649533 }, { lat: 41.8902614, lon: 12.493087103595503}]`

Safe travels!
