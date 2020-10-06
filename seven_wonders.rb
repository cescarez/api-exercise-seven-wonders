require 'httparty'
require "awesome_print"
require 'dotenv'

Dotenv.load

LOCATION_IQ_KEY = ENV['LOCATION_IQ_KEY']
BASE_URL = "https://us1.locationiq.com/v1/search.php?key=YOUR_PRIVATE_TOKEN&q=SEARCH_STRING&format=json"
# DIRECTIONS_URL = "https://us1.locationiq.com/v1/directions/driving/{coordinates}?key=<YOUR_ACCESS_TOKEN>&option=value&option=value"
DIRECTIONS_URL = "https://us1.locationiq.com/v1/{service}/{profile}/{coordinates}?key=<YOUR_ACCESS_TOKEN>&option=value&option=value"
REVERSE_GEOCODE_URL = "https://us1.locationiq.com/v1/reverse.php?key=YOUR_PRIVATE_TOKEN&lat=LATITUDE&lon=LONGITUDE&format=json"

def get_location(search_term)

  query = {
    key: LOCATION_IQ_KEY,
    q: search_term,
  }

  location_info = check_response(HTTParty.get(BASE_URL, query: query))

  latitude =  location_info.first["lat"]
  longitude =  location_info.first["lon"]


  #if check_response returns an HTTP response, return it to the caller, else return the error message
  if location_info.class == HTTParty::Response
    return { search_term => { lat: latitude, lon: longitude } }
  else
    return location_info
  end

end

def driving_directions(start_point, end_point)

  coordinates = get_start_and_end_coordinates(start_point, end_point)

  query = {
    service: "directions",
    profile: "driving",
    key: LOCATION_IQ_KEY,
    coordinates: coordinates
  }

  driving_directions = check_response(HTTParty.get(DIRECTIONS_URL, query: query))

  # new_url = DIRECTIONS_URL.gsub("{coordinates}", coordinates)
  # driving_directions = check_response(HTTParty.get(new_url, query: query))


  #if check_response returns an HTTP response, return it to the caller, else return the error message
  if driving_directions.class == HTTParty::Response
    step_by_step_directions = driving_directions["legs"].flat_map { |leg| leg["steps"] }
    return step_by_step_directions
  else
    return driving_directions
  end

end

def get_start_and_end_coordinates(start_point, end_point)

  start_coordinates = get_location(start_point)[start_point]
  sleep(0.5)
  end_coordinates = get_location(end_point)[end_point]

  return "#{start_coordinates[:lon]},#{start_coordinates[:lat]};#{end_coordinates[:lon]},#{end_coordinates[:lat]}"

end

def check_response(response)

  if response.code != 200 || response.message != "OK"
    return "API request error code #{response.code} due to #{response["error"] ||= response["code"] ||= response["type"] ||= response.message}."
  else
    return response
  end

end

def get_first_name(string)
  # raise ArgumentError, "Error no location found." if string.nil?
  return string.split(',').first if string
end

def reverse_geocode(lat:, lon:)

  query = {
    key: LOCATION_IQ_KEY,
    lat: :lat,
    lon: :lon,
  }

  # DOESN'T WORK
  location_name = check_response(HTTParty.get(REVERSE_GEOCODE_URL, query))

  #if check_response returns an HTTP response, return it to the caller, else return the error message
  if location_name.class == HTTParty::Response
    return get_first_name(location_name["display_name"])
  else
    return location_name
  end

end

def find_seven_wonders

  seven_wonders = ["Great Pyramid of Giza", "Gardens of Babylon", "Colossus of Rhodes", "Pharos of Alexandria", "Statue of Zeus at Olympia", "Temple of Artemis", "Mausoleum at Halicarnassus"]

  seven_wonders_locations = []

  seven_wonders.each do |wonder|
    sleep(0.5)
    seven_wonders_locations << get_location(wonder)
  end

  return seven_wonders_locations
end

def find_location_names

  coordinates = [{ lat: 38.8976998, lon: -77.0365534886228}, {lat: 48.4283182, lon: -123.3649533 }, { lat: 41.8902614, lon: 12.493087103595503}]

  location_names = coordinates.map do |coord_pair|
    sleep(0.5)
    reverse_geocode(lat: coord_pair[:lat], lon: coord_pair[:lon])
  end

  return location_names

end


# Use awesome_print because it can format the output nicely
# Expecting something like:
# [{"Great Pyramid of Giza"=>{:lat=>"29.9791264", :lon=>"31.1342383751015"}}, {"Gardens of Babylon"=>{:lat=>"50.8241215", :lon=>"-0.1506162"}}, {"Colossus of Rhodes"=>{:lat=>"36.3397076", :lon=>"28.2003164"}}, {"Pharos of Alexandria"=>{:lat=>"30.94795585", :lon=>"29.5235626430011"}}, {"Statue of Zeus at Olympia"=>{:lat=>"37.6379088", :lon=>"21.6300063"}}, {"Temple of Artemis"=>{:lat=>"32.2818952", :lon=>"35.8908989553238"}}, {"Mausoleum at Halicarnassus"=>{:lat=>"37.03788265", :lon=>"27.4241455276707"}}]

ap find_seven_wonders

#DRIVER CODE FOR OPTIONALS

# driving directions from Cairo to the Great Pyramid of Giza
# ap driving_directions("Cairo Egypt", "Great Pyramid of Giza")

#reverse geocode for provided list of coordinates
# ap find_location_names