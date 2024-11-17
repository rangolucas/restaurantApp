require './domain/restaurant/Store'

class CreateStore
  def initialize(store_repository)
    @store_repository = store_repository
  end
  
  def invoke(coordinates, time_table, contact_info)
    new_store = @store_repository.create_store(coordinates, time_table, contact_info)
    new_store.id
  end
end