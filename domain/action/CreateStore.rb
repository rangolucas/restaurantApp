require './domain/restaurant/Store'

class CreateStore
  def initialize(stores)
    @stores = stores
    @next_id = 0
  end
  
  def invoke(coordinates, time_table, contact_info)
    store = Store.new(@next_id, coordinates, time_table, contact_info)
    @stores.push(store)
    @next_id += 1
    return store.id
  end
end