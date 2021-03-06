require 'httparty'
require "awesome_print"
require 'dotenv'

Dotenv.load

LOCATION_IQ_KEY = ENV['LOCATION_IQ_KEY']
BASE_URL = "https://us1.locationiq.com/v1/search.php?key=YOUR_PRIVATE_TOKEN&q=SEARCH_STRING&format=json"
DIRECTIONS_URL = "https://us1.locationiq.com/v1/directions/driving/{coordinates}?key=<YOUR_ACCESS_TOKEN>"
REVERSE_GEOCODE_URL = "https://us1.locationiq.com/v1/reverse.php?key=YOUR_PRIVATE_TOKEN&lat=LATITUDE&lon=LONGITUDE&format=json"

module SevenWonders

  def self.find_coordinates(places)
    coordinates = places.map do |place|
      sleep(0.5)
      get_location(place)
    end

    return coordinates

  end

  def self.driving_directions(start_point, end_point)

    coordinates = get_start_and_end_coordinates(start_point, end_point)

    query = {
        key: LOCATION_IQ_KEY,
    }

    new_url = DIRECTIONS_URL.gsub("{coordinates}", coordinates)
    driving_directions = check_response(HTTParty.get(new_url, query: query))

    #if check_response returns an HTTP response, return  specific data in response, else return the whole object (suspected to be error message)
    if driving_directions.class == HTTParty::Response
      step_by_step_directions = driving_directions["routes"].map { |route| route["legs"] }.flatten
      return step_by_step_directions
    else
      return driving_directions
    end

  end

  def self.find_location_names(coordinates)

    location_names = coordinates.map do |coord_pair|
      sleep(0.5)
      reverse_geocode(coord_pair[:lat], coord_pair[:lon])
    end

    return location_names

  end

  private

  def self.get_location(search_term)

    query = {
      key: LOCATION_IQ_KEY,
      q: search_term,
    }

    location_info = check_response(HTTParty.get(BASE_URL, query: query))

    latitude =  location_info.first["lat"]
    longitude =  location_info.first["lon"]

    #if check_response returns an HTTP response, return  specific data in response, else return the whole object (suspected to be error message)
    if location_info.class == HTTParty::Response
      return { search_term => { lat: latitude, lon: longitude } }
    else
      return location_info
    end

  end

  def self.get_start_and_end_coordinates(start_point, end_point)

    sleep(0.5)
    start_coordinates = get_location(start_point)[start_point]
    sleep(0.5)
    end_coordinates = get_location(end_point)[end_point]
    sleep(0.5)

    return "#{start_coordinates[:lon]},#{start_coordinates[:lat]};#{end_coordinates[:lon]},#{end_coordinates[:lat]}"

  end

  def self.check_response(response)

    if response.code != 200 || response.message != "OK"
      return "API request error code #{response.code} due to #{response["error"] ||= response["code"] ||= response["type"] ||= response.message}."
    else
      return response
    end

  end

  def self.reverse_geocode(lat, lon)

    query = {
      key: LOCATION_IQ_KEY,
      lat: lat,
      lon: lon,
    }
    location_name = check_response(HTTParty.get(REVERSE_GEOCODE_URL, query: query))

    #if check_response returns an HTTP response, return  specific data in response, else return the whole object (suspected to be error message)
    if location_name.class == HTTParty::Response
      return location_name["display_name"]
    else
      return location_name
    end

  end

end

#driver code
def main

  puts "coordinates for provided list of Wonders"
  wonders = ["Great Pyramid of Giza", "Gardens of Babylon", "Colossus of Rhodes", "Pharos of Alexandria", "Statue of Zeus at Olympia", "Temple of Artemis", "Mausoleum at Halicarnassus"]
  ap SevenWonders.find_coordinates(wonders)

  # OPTIONALS
  puts "driving directions from Cairo, Egypt to the Great Pyramid of Giza"
  ap SevenWonders.driving_directions("Cairo Egypt", "Great Pyramid of Giza")

  puts "names of locations for provided list of coordinates"
  coordinates = [{ lat: 38.8976998, lon: -77.0365534886228}, {lat: 48.4283182, lon: -123.3649533 }, { lat: 41.8902614, lon: 12.493087103595503}]
  ap SevenWonders.find_location_names(coordinates)

end

#call driver
main