require 'geokit'

class MakeAnOrder
  def initialize(store_repository)
    @store_repository = store_repository
  end

  # Returns true only if the user is 50 meters within the store radius
  def invoke(store_id, user_id, amount_by_item, user_coordinates)
    store = @store_repository.fetch_by_id(store_id)
    if store.is_close_to(user_coordinates)
      @store_repository.update_store(
        store_id,
        -> (saved_store) { saved_store.register_order(user_id, amount_by_item) }
      )
      true
    else
      false
    end
  end
end