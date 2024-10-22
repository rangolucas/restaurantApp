require 'geokit'

class MakeAnOrder
  def initialize(stores)
    @stores = stores
  end

  # Returns true only if the user is 50 meters within the store radius
  def invoke(storeId, userId, amountByItem, userCoordinates)
    if validateCoordinates(store[storeId], userCoordinates)
      stores[storeId].registerOrder(userId, amountByItem)
      true
    else
      false
    end
  end

  def validateCoordinates(store, userCoordinates)
    distance_between_coordinates(store[0], store[1], userCoordinates[0], userCoordinates[1]) < 50
  end

  def distance_between_coordinates(lat1, lon1, lat2, lon2)
    loc1 = Geokit::LatLng.new(lat1, lon1)
    loc2 = Geokit::LatLng.new(lat2, lon2)
    loc1.distance_to(loc2, units: :meters)
  end
end