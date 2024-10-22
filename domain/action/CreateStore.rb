require './domain/restaurant/Store'

class CreateStore
  def initialize(stores)
    @stores = stores
    @nextId = 0
  end
  
  def invoke(coordinates, timeTable, contactInfo)
    store = Store.new(@nextId, coordinates, timeTable, contactInfo)
    @stores.push(store)
    @nextId += 1
    return store.id
  end
end