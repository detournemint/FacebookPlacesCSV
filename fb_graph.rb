require 'fb_graph'
require 'geoip'
require 'csv'

def get_location(ipaddress)
  geo = GeoIP.new('GeoLiteCity.dat').city(ipaddress)
  location = geo.latitude.to_s + ',' + geo.longitude.to_s
end


def csv_places(term, location, distance)
  places = FbGraph::Place.search(term, :center => location, :distance => distance, :access_token => access_token)
  CSV.open("data.csv", "wb") do |csv|
    csv << ["name", "street", "phone" ]
    places.each do |place|
      csv << [place.name, place.location.street, place.phone]
    end
  end
end



puts "Enter Your Search Term"
  search = gets.chomp
puts "and enter the distance from you in km"
  distance = gets.chomp
puts "getting location"
  location = `curl -s checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'`
  location = get_location(location)
puts "generating CSV file"

csv_places(search, location, distance.to_i)

puts "DONE"