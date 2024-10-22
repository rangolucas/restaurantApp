require 'geokit'

class MakeAnOrder
  def initialize(stores)
    @stores = stores
  end

  # Returns true only if the user is 50 meters within the store radius
  def invoke(store_id, user_id, amount_by_item, user_coordinates)
    if validate_coordinates(store[store_id], user_coordinates)
      stores[store_id].register_order(user_id, amount_by_item)
      true
    else
      false
    end
  end

  def validate_coordinates(store, user_coordinates)
    distance_between_coordinates(store[0], store[1], user_coordinates[0], user_coordinates[1]) < 50
  end

  def distance_between_coordinates(lat1, lon1, lat2, lon2)
    loc1 = Geokit::LatLng.new(lat1, lon1)
    loc2 = Geokit::LatLng.new(lat2, lon2)
    loc1.distance_to(loc2, units: :meters)
  end
end