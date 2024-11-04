require 'json'

class StoreController
  def initialize(create_store_action, get_stores_action)
    @create_store_action = create_store_action
    @get_stores_action = get_stores_action
  end

  def create_store(request)
    coordinates = request['coordinates']
    time_table = request['timeTable']
    contact_info = request['contactInfo']
    @create_store_action.invoke(coordinates, time_table, contact_info)
  end

  def get_stores
    @get_stores_action.invoke().map { |s| encode_to_json(s) }.to_json
  end

  private

  def encode_to_json(store)
    {
      "id": store.id,
      "contact": store.contact_info
    }
  end
end