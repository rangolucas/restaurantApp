require 'json'

require './domain/Coordinates'

class StoreController
  def initialize(create_store_action, get_stores_action)
    @create_store_action = create_store_action
    @get_stores_action = get_stores_action
  end

  def create_store(request)
    coordinates = decode_coordinates(request['coordinates'])
    store_id = @create_store_action.invoke(coordinates, request['timeTable'], request['contactInfo'])
    encode_store_id_to_json(store_id)
  end

  def get_stores
    all_stores = @get_stores_action.invoke
    encode_stores_to_json(all_stores)
  end

  private

  def encode_store_to_json(store)
    {
      "id": store.id,
      "contact": store.contact_info,
      "coordinates": encode_coordinates_to_json(store.coordinates)
    }
  end

  def encode_stores_to_json(stores)
    stores.map { |s| encode_store_to_json(s) }.to_json
  end

  def encode_coordinates_to_json(coordinates)
    [coordinates.lat, coordinates.lon]
  end

  def encode_store_id_to_json(id)
    {
      "id": id
  }.to_json
  end

  def decode_coordinates((lat, lon))
    Coordinates.new(lat, lon)
  end
end