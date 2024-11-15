require 'geokit'

class MakeAnOrder
  def initialize(store_repository)
    @store_repository = store_repository
  end

  # Returns true only if the user is 50 meters within the store radius
  def invoke(store_id, user_id, amount_by_item, user_coordinates)
    store = @store_repository.fetch_by_id(store_id)
    if validate_proximity(store, user_coordinates)
      store.register_order(user_id, amount_by_item)
      @store_repository.update_store(store)
      true
    else
      false
    end
  end

  def validate_proximity(store, user_coordinates)
    store_coordinates = store.coordinates
    distance_between_coordinates(store_coordinates[0], store_coordinates[1], user_coordinates[0], user_coordinates[1]) < 50 # TODO: parameterize proximity threshold through dependency injection
  end

  def distance_between_coordinates(lat1, lon1, lat2, lon2)
    loc1 = Geokit::LatLng.new(lat1, lon1)
    loc2 = Geokit::LatLng.new(lat2, lon2)
    loc1.distance_to(loc2, units: :meters)
  end
end