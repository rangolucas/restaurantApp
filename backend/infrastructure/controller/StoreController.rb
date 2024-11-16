require 'json'

class StoreController
  def initialize(create_store_action, get_stores_action)
    @create_store_action = create_store_action
    @get_stores_action = get_stores_action
  end

  def create_store(request)
    store_id = @create_store_action.invoke(request['coordinates'], request['timeTable'], request['contactInfo'])
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
      "coordinates": store.coordinates
    }
  end

  def encode_stores_to_json(stores)
    stores.map { |s| encode_store_to_json(s) }.to_json
  end

  def encode_store_id_to_json(id)
    {
      "id": id
  }.to_json
  end
end