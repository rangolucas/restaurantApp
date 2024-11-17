require './domain/restaurant/Store'

class CreateStore
  def initialize(store_repository)
    @store_repository = store_repository
  end
  
  def invoke(coordinates, name, time_table, contact_info)
    new_store = @store_repository.create_store(coordinates, name, time_table, contact_info)
    new_store.id
  end
end