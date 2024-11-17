class Coordinates
  attr_reader :lat, :lon
  
  def initialize(lat, lon)
    @lat = lat
    @lon = lon
  end

  def distance_to(other_coordinates, units:)
    loc1 = Geokit::LatLng.new(@lat, @lon)
    loc2 = Geokit::LatLng.new(other_coordinates.lat, other_coordinates.lon)
    loc1.distance_to(loc2, units: units)
  end
end